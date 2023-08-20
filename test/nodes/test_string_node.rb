require "test_helper"

class TestStringNode < Minitest::Test
  def setup
    @string = '"hello world"'
    @context = {}
    @interval = 0..@string.length
  end

  def test_string_evaluate
    node = Confuscript::Nodes::StringNode.new(@string, @interval)
    result = node.evaluate(@context)
    assert_equal "hello world", result
  end
end
