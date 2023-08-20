require "test_helper"

class TestExpressionNode < Minitest::Test
  def test_evaluate_when_value
    @node = Confuscript.parser.parse("5;")

    assert_equal 5, @node.evaluate(@context)
  end
end