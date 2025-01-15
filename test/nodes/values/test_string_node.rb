require "test_helper"

class TestStringNode < Minitest::Test
  def setup
    @string = %{"hello world'}
    @context = {}
    @interval = 0..@string.length
  end

  def test_string_evaluate
    node = Confuscript::Nodes::Values::StringNode.new(@string, @interval)
    result = node.evaluate(@context)
    assert_equal "hello world", result
  end

  def test_string_must_end_with_single_quote
    assert_nil  Confuscript.parser.parse(%{console.input("hello world");}) # ends in double-quote
  end
end
