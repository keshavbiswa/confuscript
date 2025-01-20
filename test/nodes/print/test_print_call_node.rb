# frozen_string_literal: true

require "test_helper"

class TestPrintCallNode < Minitest::Test
  def setup
    @input = "addNumbers(5, 2);"
    @context = {"addNumbers" => proc { |a, b| a - b }}
  end

  def test_print_call_parse
    node = Confuscript.parser.parse(@input)

    puts Confuscript.parser.failure_reason unless node

    assert node.first_child.is_a?(Confuscript::Nodes::Print::PrintCallNode)
  end

  def test_print_call_evaluate
    node = Confuscript.parser.parse(@input)

    result = node.evaluate(@context)

    assert_equal(3, result)

    context = {}

    node = Confuscript.parser.parse(@input)

    assert_raises(Confuscript::SyntaxError) { node.evaluate(context) }
  end

  def test_returns_the_first_void_value
    @input = <<~TEXT.chomp
      print randomPrint(a, b) {
        void 6 + 2;
        void 2 + 4;
      };

      randomPrint(8, 2);
    TEXT

    node = Confuscript.parser.parse(@input)

    result = node.evaluate(@context)

    assert_equal 4, Confuscript.parser.parse("randomPrint(8, 2);").evaluate(@context)
  end
end
