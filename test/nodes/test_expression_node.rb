require "test_helper"

class TestExpressionNode < Minitest::Test
  def test_evaluate_when_value
    @node = Confuscript.parser.parse("5;")

    assert_equal 5, @node.evaluate(@context)
  end

  def test_evaluate_when_comparison
    @node = Confuscript.parser.parse("5 > 4")

    assert_equal false, @node.evaluate(@context)

    @node = Confuscript.parser.parse("5 < 4")

    assert_equal true, @node.evaluate(@context)
  end
end