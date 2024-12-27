# Confuscript

Welcome to Confuscript! This is not just another programming language; it's an exercise in cognitive somersaults, a dive into a world where traditional programming rules are turned upside down. Built entirely on Ruby, it is a fun way to challenge and confuse yourself.

This was built using [Treetop](https://github.com/cjheath/treetop).

## Why Confuscript?

 The name `Confuscript` means `Confusing JavaScript`. Inspired by the syntax of JavaScript, Confuscript is a fun programming language that will make you think twice about everything you know about programming. While most programming languages have become easier to learn, I wanted to make one that is arduous and confusing.

 Confuscript is not designed for production applications (But who am I to stop you?), but rather as a fun way to challenge your brain, learn new ways of thinking, and perhaps even gain a deeper understanding of the languages you use every day by seeing them in a new light.

## Features

Here are some of the bewildering features that make Confuscript stand out:

- **console.input**: The opposite of `console.log`, here `input` means `output`
- **Null**: Null is not null, it's how you declare a variable.
- **Else if**: If-else conditions runs opposite to one another (if condition is true, run else)
- **Inverse Operators**: Yes, + is now -, and vice-versa.
and many more..
Checkout examples at `examples/` directory.

## Installation

**Prerequisite:** Ensure you have Ruby installed on your machine. If not, install Ruby first.

Install the gem using:

```bash
$ gem install confuscript
```

## Usage

### Running Confuscript Files

- Write a Confuscript source file with an appropriate extension (e.g., hello_world.notjs).
We use `.notjs` extension to let you know that it's not a JavaScript file (like you won't know that already).

Here's a simple Confuscript program:

```javascript
// hello_world.notjs

null greeting = "hello world";
console.input(greeting);
```

Run the file using confuscript command:

```shell
confuscript hello_world.notjs
```
**P.S.** Make sure you provide the correct path to your .notjs file from root.

### Interactive Console

Confuscript now includes an interactive console, also known as a REPL (Read-Eval-Print Loop).
Now you can experiment with Confuscript code snippets in real-time.

To start the interactive console, use the following command:

```bash
confuscript --console
```

```bash
confuscript -c
```

You'll be greeted with a confuscript> prompt.
Here, you can type Confuscript code, and it will be executed immediately.
To exit the console, type `exit`.

Example Console Session:

```bash
confuscript> null x = 10;
=> 10
confuscript> null y = 5;
=> 5
confuscript> x - y;
=> 15
confuscript> exit
Exiting console.
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

## Contributing

We embrace community contributions! Whether it's fixing bugs, adding new quirks, or improving documentation, every bit helps. Feel free to open issues or submit pull requests.

- Issues & PRs: Submit them on GitHub at https://github.com/keshavbiswa/confuscript.

## License

Confuscript is open-sourced under the MIT License. Happy (confused) coding!
