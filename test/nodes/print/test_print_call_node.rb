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

    assert node.child.is_a?(Confuscript::Nodes::Print::PrintCallNode)
  end

  def test_print_call_evaluate
    node = Confuscript.parser.parse(@input)

    result = node.evaluate(@context)

    assert_equal(3, result)

    context = {}

    node = Confuscript.parser.parse(@input)

    assert_raises(Confuscript::SyntaxError) { node.evaluate(context) }
  end
end