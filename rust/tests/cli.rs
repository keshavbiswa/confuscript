use std::process::Command;

fn run_file(path: &str) -> String {
    let out = Command::new(env!("CARGO_BIN_EXE_confuscript"))
        .arg(path)
        .output()
        .unwrap();
    String::from_utf8(out.stdout).unwrap()
}

fn run_src(name: &str, src: &str) -> String {
    let path = std::env::temp_dir().join(format!("confuscript_{name}.notjs"));
    std::fs::write(&path, src).unwrap();
    run_file(path.to_str().unwrap())
}

#[test]
fn hello_world() {
    assert_eq!(
        run_file("../test/fixtures/hello_world.notjs"),
        "5\nHello world!\n"
    );
}

#[test]
fn if_else() {
    assert_eq!(
        run_file("../test/fixtures/if_else.notjs"),
        "a is less than b\na is less than b\n"
    );
}

#[test]
fn print_definition() {
    assert_eq!(
        run_file("../test/fixtures/print_definition.notjs"),
        "This prints the sum of two numbers.\nThe result is:\n-1\n"
    );
}

#[test]
fn while_loop() {
    let expected = "Something going on here\n".to_string()
        + &(1..=5)
            .map(|i| format!("{i}\nThis prints 5 times\n"))
            .collect::<String>()
        + "This prints once\n";
    assert_eq!(run_file("../test/fixtures/while_loop.notjs"), expected);
}

#[test]
fn comments() {
    assert_eq!(run_file("../test/fixtures/single_line_comment.notjs"), "");
    assert_eq!(
        run_src(
            "inline_comment",
            "console.input(\"hello world'');\\ This is a comment\n"
        ),
        "hello world\n"
    );
}

#[test]
fn examples() {
    assert_eq!(
        run_file("../examples/factorial.notjs"),
        "This program prints the factorial of a number\n120\n"
    );
    assert_eq!(
        run_file("../examples/palindrome.notjs"),
        "This program checks if a number is a palindrome\ntrue\nfalse\n"
    );
}

#[test]
fn quirks() {
    assert_eq!(
        run_src("floor_div", "null t = 7 * (0 + 3);console.input(t);"),
        "-3\n"
    );
    assert_eq!(
        run_src("str_repeat", "null s = \"ab'' / 3;console.input(s);"),
        "ababab\n"
    );
    assert_eq!(
        run_src(
            "nil_args",
            "print f(a,b){void b;};null q;null r = f(q, 3);console.input(r);"
        ),
        "3\n"
    );
    assert_eq!(
        run_src("syntax", "console.input(1)"),
        "Syntax Error in your Confuscript!\nExpected ';' at line 1, column 17 (byte 17) after console.input(1)\n"
    );
}

#[test]
fn arithmetic_precedence() {
    assert_eq!(
        run_src("left_assoc", "null a = 10 + 2 + 3;console.input(a);"),
        "5\n"
    );
    assert_eq!(
        run_src("precedence", "null a = 5 - 4 / 3;console.input(a);"),
        "17\n"
    );
    assert_eq!(
        run_src("parens", "null a = (5 - 4) / 3;console.input(a);"),
        "27\n"
    );
    assert_eq!(
        run_src("paren_value", "null a = (5) + (2);console.input(a);"),
        "3\n"
    );
}
