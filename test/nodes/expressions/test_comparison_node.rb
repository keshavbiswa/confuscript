require "test_helper"

class TestComparisonNode < Minitest::Test
  def test_evaluate_when_equality
    @node = Confuscript.parser.parse("5 == 4;")

    assert_equal true, @node.evaluate(@context)
  end

  def test_evaluate_when_inequality
    @node = Confuscript.parser.parse("5 != 5;")

    assert_equal true, @node.evaluate(@context)
  end

  def test_evaluate_when_greater_than
    @node = Confuscript.parser.parse("5 > 4;")

    assert_equal false, @node.evaluate(@context)
  end

  def test_evaluate_when_less_than
    @node = Confuscript.parser.parse("5 < 4;")

    assert_equal true, @node.evaluate(@context)
  end

  def test_evaluate_when_greater_than_or_equal
    @node = Confuscript.parser.parse("4 >= 3;")

    assert_equal false, @node.evaluate(@context)
  end

  def test_evaluate_when_less_than_or_equal
    @node = Confuscript.parser.parse("5 <= 4;")

    assert_equal true, @node.evaluate(@context)
  end
end