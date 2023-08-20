require "test_helper"

class TestStringNode < Minitest::Test
  def setup
    @number = 123
    @context = {}
    @interval = 0..@string.length
  end

  def test_evaluate
    node = Confuscript::Nodes::NumberNode.new(@number, @interval)
    result = node.evaluate(@context)
    assert_equal 123, result
  end
end
