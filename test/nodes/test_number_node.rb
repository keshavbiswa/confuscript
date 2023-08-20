require "test_helper"

class TestNumberNode < Minitest::Test
  def setup
    @number = "123"
    @context = {}
    @interval = 0..@number.length
  end

  def test_number_evaluate
    node = Confuscript::Nodes::NumberNode.new(@number, @interval)
    result = node.evaluate(@context)

    assert_equal 123, result
  end
end
