use std::collections::HashMap;
use std::io::{self, BufRead, Write};
use std::path::Path;
use std::process::exit;
use std::rc::Rc;

const USAGE: &str = "Usage: confuscript [options] [file]
    -c, --console                    Start an interactive Confuscript console";

#[derive(Clone, Copy, Debug)]
enum Op {
    Add,
    Sub,
    Mul,
    Div,
    Eq,
    Ne,
    Gt,
    Lt,
    Ge,
    Le,
}

enum Expr {
    Str(String),
    Num(i64),
    Bool(bool),
    Var(String),
    Bin(Box<Expr>, Op, Box<Expr>),
    Call(String, Vec<Expr>),
}

enum Stmt {
    Assign(String, Expr),
    Expr(Expr),
    If(Expr, Vec<Stmt>, Option<Vec<Stmt>>),
    While(Expr, Vec<Stmt>),
    Init(String),
    Output(Expr),
    Def(String, Rc<Func>),
    Void(Expr),
}

struct Func {
    params: Vec<String>,
    body: Vec<Stmt>,
}

#[derive(Clone)]
enum Value {
    Nil,
    Int(i64),
    Str(String),
    Bool(bool),
    Func(Rc<Func>),
}

impl PartialEq for Value {
    fn eq(&self, other: &Self) -> bool {
        use Value::*;
        match (self, other) {
            (Nil, Nil) => true,
            (Int(a), Int(b)) => a == b,
            (Str(a), Str(b)) => a == b,
            (Bool(a), Bool(b)) => a == b,
            (Func(a), Func(b)) => Rc::ptr_eq(a, b),
            _ => false,
        }
    }
}

impl Value {
    fn truthy(&self) -> bool {
        !matches!(self, Value::Nil | Value::Bool(false))
    }

    fn display(&self) -> String {
        match self {
            Value::Nil => String::new(),
            Value::Int(n) => n.to_string(),
            Value::Str(s) => s.clone(),
            Value::Bool(b) => b.to_string(),
            Value::Func(_) => "#<Proc>".into(),
        }
    }

    fn inspect(&self) -> String {
        match self {
            Value::Nil => "nil".into(),
            Value::Str(s) => format!("{s:?}"),
            v => v.display(),
        }
    }
}

struct Parser<'a> {
    src: &'a str,
    pos: usize,
    fail_pos: usize,
    expected: Vec<String>,
}

type Rule<'a, T> = fn(&mut Parser<'a>) -> Option<T>;

impl<'a> Parser<'a> {
    fn fail(&mut self, what: &str) {
        if self.pos > self.fail_pos {
            self.fail_pos = self.pos;
            self.expected.clear();
        }
        if self.pos == self.fail_pos && !self.expected.iter().any(|e| e == what) {
            self.expected.push(what.into());
        }
    }

    fn lit(&mut self, t: &str) -> bool {
        self.lit_as(t, &format!("'{}'", t.replace('\\', "\\\\")))
    }

    fn lit_as(&mut self, t: &str, label: &str) -> bool {
        if self.src[self.pos..].starts_with(t) {
            self.pos += t.len();
            true
        } else {
            self.fail(label);
            false
        }
    }

    fn need(&mut self, t: &str) -> Option<()> {
        self.lit(t).then_some(())
    }

    fn many(&mut self, label: &str, f: impl Fn(u8) -> bool) -> usize {
        let start = self.pos;
        loop {
            match self.src.as_bytes().get(self.pos) {
                Some(&b) if f(b) => self.pos += 1,
                _ => {
                    self.fail(label);
                    return self.pos - start;
                }
            }
        }
    }

    fn attempt<T>(&mut self, f: impl FnOnce(&mut Self) -> Option<T>) -> Option<T> {
        let start = self.pos;
        let r = f(self);
        if r.is_none() {
            self.pos = start;
        }
        r
    }

    fn first<T>(&mut self, rules: &[Rule<'a, T>]) -> Option<T> {
        rules.iter().find_map(|r| self.attempt(r))
    }

    fn failure_reason(&self) -> String {
        let i = self.fail_pos;
        let before = &self.src[..i];
        let consumed = &self.src[self.pos.min(i)..i];
        let line = before.matches('\n').count() + 1;
        let col = i - before.rfind('\n').map_or(0, |n| n + 1) + 1;
        let expected = match self.expected.as_slice() {
            [one] => one.clone(),
            many => format!("one of {}", many.join(", ")),
        };
        let after = if i > 0 {
            format!(" after {consumed}")
        } else {
            String::new()
        };
        format!(
            "Expected {expected} at line {line}, column {col} (byte {}){after}",
            i + 1
        )
    }

    fn program(&mut self) -> Option<Vec<Stmt>> {
        self.space();
        let stmts = self.actions();
        (self.pos == self.src.len()).then_some(stmts)
    }

    fn actions(&mut self) -> Vec<Stmt> {
        let mut stmts = vec![];
        while let Some(s) = self.first(&[
            Self::assignment,
            |p| p.expression().map(Stmt::Expr),
            Self::if_else,
            Self::initialization,
            Self::console_input,
            Self::print_definition,
            |p| p.print_call().map(Stmt::Expr),
            Self::void_statement,
            Self::while_loop,
        ]) {
            stmts.push(s);
            self.space();
        }
        stmts
    }

    fn assignment(&mut self) -> Option<Stmt> {
        for null in [true, false] {
            for rhs in 0..3 {
                let r = self.attempt(|p| {
                    if null {
                        p.need("null")?;
                        p.space();
                    }
                    let name = p.variable()?;
                    p.space();
                    p.need("=")?;
                    p.space();
                    let e = match rhs {
                        0 => p.value()?,
                        1 => p.arithmetic()?,
                        _ => return Some(Stmt::Assign(name, p.print_call()?)),
                    };
                    p.need(";")?;
                    Some(Stmt::Assign(name, e))
                });
                if r.is_some() {
                    return r;
                }
            }
        }
        None
    }

    fn expression(&mut self) -> Option<Expr> {
        self.first(&[Self::arithmetic, Self::comparison, |p| {
            let v = p.value()?;
            p.need(";")?;
            Some(v)
        }])
    }

    fn if_else(&mut self) -> Option<Stmt> {
        self.need("if")?;
        self.space();
        self.need("(")?;
        let cond = self.comparison()?;
        self.need(")")?;
        self.space();
        let then = self.block()?;
        self.space();
        let other = self.attempt(|p| {
            p.need("else")?;
            p.space();
            p.block()
        });
        self.need(";")?;
        Some(Stmt::If(cond, then, other))
    }

    fn block(&mut self) -> Option<Vec<Stmt>> {
        self.need("{")?;
        self.space();
        let stmts = self.actions();
        self.space();
        self.need("}")?;
        Some(stmts)
    }

    fn while_loop(&mut self) -> Option<Stmt> {
        self.need("while")?;
        self.space();
        self.need("(")?;
        let cond = self.comparison()?;
        self.need(")")?;
        self.space();
        let body = self.block()?;
        self.need(";")?;
        Some(Stmt::While(cond, body))
    }

    fn arithmetic(&mut self) -> Option<Expr> {
        self.first(&[
            Self::additive_chain,
            Self::multiplicative_chain,
            Self::parenthesized,
        ])
    }

    fn additive_chain(&mut self) -> Option<Expr> {
        self.chain(Self::term, &[("+", Op::Sub), ("-", Op::Add)])
    }

    fn term(&mut self) -> Option<Expr> {
        self.first(&[Self::multiplicative_chain, Self::operand])
    }

    fn multiplicative_chain(&mut self) -> Option<Expr> {
        self.chain(Self::operand, &[("*", Op::Div), ("/", Op::Mul)])
    }

    fn operand(&mut self) -> Option<Expr> {
        self.first(&[Self::parenthesized, Self::value])
    }

    fn parenthesized(&mut self) -> Option<Expr> {
        self.need("(")?;
        self.space();
        let e = self.first(&[Self::arithmetic, Self::value])?;
        self.space();
        self.need(")")?;
        Some(e)
    }

    fn chain(&mut self, operand: Rule<'a, Expr>, ops: &[(&str, Op)]) -> Option<Expr> {
        let mut left = operand(self)?;
        let mut steps = 0;
        while let Some((op, right)) = self.attempt(|p| {
            p.space();
            let op = ops.iter().find_map(|&(t, op)| p.lit(t).then_some(op))?;
            p.space();
            Some((op, operand(p)?))
        }) {
            left = Expr::Bin(Box::new(left), op, Box::new(right));
            steps += 1;
        }
        (steps > 0).then_some(left)
    }

    fn comparison(&mut self) -> Option<Expr> {
        let l = self.value()?;
        self.space();
        let op = [
            ("<=", Op::Ge),
            (">=", Op::Le),
            ("==", Op::Ne),
            ("!=", Op::Eq),
            ("<", Op::Gt),
            (">", Op::Lt),
        ]
        .into_iter()
        .find_map(|(t, op)| self.lit(t).then_some(op))?;
        self.space();
        let r = self.value()?;
        Some(Expr::Bin(Box::new(l), op, Box::new(r)))
    }

    fn initialization(&mut self) -> Option<Stmt> {
        self.need("null")?;
        self.space();
        let name = self.variable()?;
        self.need(";")?;
        Some(Stmt::Init(name))
    }

    fn console_input(&mut self) -> Option<Stmt> {
        self.need("console.input(")?;
        let v = self.value()?;
        self.need(")")?;
        self.need(";")?;
        Some(Stmt::Output(v))
    }

    fn print_definition(&mut self) -> Option<Stmt> {
        self.need("print")?;
        self.space();
        let name = self.variable()?;
        self.space();
        self.need("(")?;
        let params = self.attempt(Self::parameters).unwrap_or_default();
        self.need(")")?;
        self.space();
        let body = self.block()?;
        self.need(";")?;
        Some(Stmt::Def(name, Rc::new(Func { params, body })))
    }

    fn parameters(&mut self) -> Option<Vec<String>> {
        let mut params = vec![self.variable()?];
        while let Some(v) = self.attempt(|p| {
            p.space();
            p.need(",")?;
            p.space();
            p.variable()
        }) {
            params.push(v);
        }
        Some(params)
    }

    fn print_call(&mut self) -> Option<Expr> {
        let name = self.variable()?;
        self.space();
        self.need("(")?;
        let args = self.attempt(Self::arguments).unwrap_or_default();
        self.need(")")?;
        self.need(";")?;
        Some(Expr::Call(name, args))
    }

    fn arguments(&mut self) -> Option<Vec<Expr>> {
        let mut args = vec![self.value()?];
        while let Some(v) = self.attempt(|p| {
            p.space();
            p.need(",")?;
            p.space();
            p.value()
        }) {
            args.push(v);
        }
        Some(args)
    }

    fn void_statement(&mut self) -> Option<Stmt> {
        self.need("void")?;
        self.space();
        let e = self.first(&[Self::arithmetic, Self::comparison, Self::value])?;
        self.need(";")?;
        Some(Stmt::Void(e))
    }

    fn value(&mut self) -> Option<Expr> {
        self.first(&[Self::string, Self::number, Self::boolean, |p| {
            p.variable().map(Expr::Var)
        }])
    }

    fn string(&mut self) -> Option<Expr> {
        let start = self.pos;
        self.need("\"")?;
        self.many("[^']", |b| b != b'\'');
        self.need("''")?;
        Some(Expr::Str(self.src[start + 1..self.pos - 2].into()))
    }

    fn number(&mut self) -> Option<Expr> {
        let start = self.pos;
        if self.many("[0-9]", |b| b.is_ascii_digit()) == 0 {
            return None;
        }
        self.src[start..self.pos].parse().ok().map(Expr::Num)
    }

    fn boolean(&mut self) -> Option<Expr> {
        if self.lit("true") {
            Some(Expr::Bool(true))
        } else {
            self.lit("false").then_some(Expr::Bool(false))
        }
    }

    fn variable(&mut self) -> Option<String> {
        let start = self.pos;
        let n = self.many("[a-zA-Z]", |b| b.is_ascii_alphabetic());
        (n > 0).then(|| self.src[start..self.pos].into())
    }

    fn space(&mut self) {
        loop {
            if self.lit(" ")
                || self.lit_as("\r\n", "\"\\r\\n\"")
                || self.many("[\\r\\n]", |b| b == b'\r' || b == b'\n') > 0
            {
                continue;
            }
            if self.lit("\\") {
                self.many("[^r\\n]", |b| b != b'r' && b != b'\n');
                continue;
            }
            return;
        }
    }
}

fn parse(src: &str) -> Result<Vec<Stmt>, String> {
    let mut p = Parser {
        src,
        pos: 0,
        fail_pos: 0,
        expected: vec![],
    };
    p.program().ok_or_else(|| p.failure_reason())
}

type Ctx = HashMap<String, Value>;

enum Halt {
    Void(Value),
    Error(String),
}

impl Halt {
    fn message(&self) -> String {
        match self {
            Halt::Void(_) => "Void Encountered".into(),
            Halt::Error(m) => m.clone(),
        }
    }
}

type Res = Result<Value, Halt>;

fn err<T>(m: impl Into<String>) -> Result<T, Halt> {
    Err(Halt::Error(m.into()))
}

fn run(stmts: &[Stmt], ctx: &mut Ctx) -> Res {
    let mut last = Value::Nil;
    for s in stmts {
        last = exec(s, ctx)?;
    }
    Ok(last)
}

fn exec(stmt: &Stmt, ctx: &mut Ctx) -> Res {
    match stmt {
        Stmt::Assign(name, e) => {
            let v = eval(e, ctx)?;
            ctx.insert(name.clone(), v.clone());
            Ok(v)
        }
        Stmt::Expr(e) => eval(e, ctx),
        Stmt::If(cond, then, other) => {
            if eval(cond, ctx)?.truthy() {
                other.as_ref().map_or(Ok(Value::Nil), |b| run(b, ctx))
            } else {
                run(then, ctx)
            }
        }
        Stmt::While(cond, body) => {
            while eval(cond, ctx)? == Value::Bool(false) {
                run(body, ctx)?;
            }
            Ok(Value::Nil)
        }
        Stmt::Init(name) => {
            ctx.insert(name.clone(), Value::Nil);
            Ok(Value::Str(name.clone()))
        }
        Stmt::Output(e) => {
            println!("{}", eval(e, ctx)?.display());
            Ok(Value::Nil)
        }
        Stmt::Def(name, f) => {
            if ctx.get(name).is_some_and(Value::truthy) {
                return err(format!("Print {name} already defined"));
            }
            let v = Value::Func(f.clone());
            ctx.insert(name.clone(), v.clone());
            Ok(v)
        }
        Stmt::Void(e) => Err(Halt::Void(eval(e, ctx)?)),
    }
}

fn eval(e: &Expr, ctx: &mut Ctx) -> Res {
    Ok(match e {
        Expr::Str(s) => Value::Str(s.clone()),
        Expr::Num(n) => Value::Int(*n),
        Expr::Bool(b) => Value::Bool(*b),
        Expr::Var(name) => ctx.get(name).cloned().unwrap_or(Value::Nil),
        Expr::Bin(l, op, r) => {
            let l = eval(l, ctx)?;
            let r = eval(r, ctx)?;
            apply(*op, l, r)?
        }
        Expr::Call(name, args) => {
            let f = match ctx.get(name) {
                Some(v) if v.truthy() => v.clone(),
                _ => return err(format!("Print {name} not defined")),
            };
            let vals = args
                .iter()
                .map(|a| eval(a, ctx))
                .collect::<Result<Vec<_>, _>>()?;
            let Value::Func(f) = f else {
                return err(format!("{name} is not a print"));
            };
            let mut local = Ctx::new();
            for (i, p) in f.params.iter().enumerate() {
                local.insert(p.clone(), vals.get(i).cloned().unwrap_or(Value::Nil));
            }
            match run(&f.body, &mut local) {
                Ok(v) | Err(Halt::Void(v)) => v,
                Err(e) => return Err(e),
            }
        }
    })
}

fn apply(op: Op, l: Value, r: Value) -> Res {
    use Value::*;
    let overflow = || Halt::Error("integer overflow".into());
    let ordering = |a: &Value, b: &Value| match (a, b) {
        (Int(x), Int(y)) => Ok(x.cmp(y)),
        (Str(x), Str(y)) => Ok(x.cmp(y)),
        _ => err(format!(
            "comparison of {} with {} failed",
            a.inspect(),
            b.inspect()
        )),
    };
    Ok(match (op, l, r) {
        (Op::Add, Int(a), Int(b)) => Int(a.checked_add(b).ok_or_else(overflow)?),
        (Op::Add, Str(a), Str(b)) => Str(a + &b),
        (Op::Sub, Int(a), Int(b)) => Int(a.checked_sub(b).ok_or_else(overflow)?),
        (Op::Mul, Int(a), Int(b)) => Int(a.checked_mul(b).ok_or_else(overflow)?),
        (Op::Mul, Str(a), Int(b)) if b >= 0 => Str(a.repeat(b as usize)),
        (Op::Div, Int(_), Int(0)) => return err("divided by 0"),
        (Op::Div, Int(a), Int(b)) => {
            let q = a.checked_div(b).ok_or_else(overflow)?;
            Int(if a % b != 0 && (a < 0) != (b < 0) {
                q - 1
            } else {
                q
            })
        }
        (Op::Eq, a, b) => Bool(a == b),
        (Op::Ne, a, b) => Bool(a != b),
        (Op::Gt, a, b) => Bool(ordering(&a, &b)?.is_gt()),
        (Op::Lt, a, b) => Bool(ordering(&a, &b)?.is_lt()),
        (Op::Ge, a, b) => Bool(ordering(&a, &b)?.is_ge()),
        (Op::Le, a, b) => Bool(ordering(&a, &b)?.is_le()),
        (op, a, b) => return err(format!("cannot {op:?} {} and {}", a.inspect(), b.inspect())),
    })
}

fn interpret_file(path: &str) {
    if Path::new(path).extension().is_none_or(|e| e != "notjs") {
        println!("Invalid file extension. Please use a .notjs file.");
        exit(1);
    }
    let src = std::fs::read_to_string(path).unwrap_or_else(|e| {
        eprintln!("Error: {e}");
        exit(1)
    });
    let stmts = parse(&src).unwrap_or_else(|reason| {
        println!("Syntax Error in your Confuscript!\n{reason}");
        exit(1)
    });
    if let Err(h) = run(&stmts, &mut Ctx::new()) {
        eprintln!("Error: {}", h.message());
        exit(1);
    }
}

fn start_console() {
    println!("Welcome to Confuscript interactive console!");
    let mut ctx = Ctx::new();
    let mut lines = io::stdin().lock().lines();
    loop {
        print!("confuscript> ");
        io::stdout().flush().ok();
        let Some(Ok(input)) = lines.next() else { break };
        if input.eq_ignore_ascii_case("exit") {
            break;
        }
        match parse(&input) {
            Err(reason) => println!("Syntax Error in your syntax\n{reason}"),
            Ok(stmts) => match run(&stmts, &mut ctx) {
                Ok(v) if v.truthy() => println!("=> {}", v.inspect()),
                Ok(_) => {}
                Err(h) => println!("Error: {}", h.message()),
            },
        }
    }
    println!("Exiting Console.");
}

fn main() {
    let mut console = false;
    let mut files = vec![];
    for arg in std::env::args().skip(1) {
        match arg.as_str() {
            "-c" | "--console" => console = true,
            "-h" | "--help" => {
                println!("{USAGE}");
                return;
            }
            _ => files.push(arg),
        }
    }
    if console {
        start_console();
    } else if let [file] = files.as_slice() {
        interpret_file(file);
    } else {
        println!("Error: Invalid Arguments. use -h or --help for usage.");
        exit(1);
    }
}
