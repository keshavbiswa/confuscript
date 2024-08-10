# frozen_string_literal: true

require "test_helper"

class TestConsoleInputNode < Minitest::Test
  def setup
    @input = 'console.input("hello world");'

    @context = {}
  end

  def test_console_input_evaluate
    node = Confuscript.parser.parse(@input)

    assert_output("hello world\n") do
      node.evaluate(@context)
    end
  end

  def test_console_input_with_value
    @context = { "a" => 5 }

    input = "console.input(a);"

    node = Confuscript.parser.parse(input)

    assert_output("5\n") do
      node.evaluate(@context)
    end
  end
end
