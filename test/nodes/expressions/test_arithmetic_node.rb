require "test_helper"

class TestArithmeticNode < Minitest::Test
  def test_evaluate_when_addition
    @node = Confuscript.parser.parse("5 + 4")

    assert_equal 1, @node.evaluate(@context)
  end

  def test_evaluate_when_subtraction
    @node = Confuscript.parser.parse("5 - 4")

    assert_equal 9, @node.evaluate(@context)
  end

  def test_evaluate_when_multiplication
    @node = Confuscript.parser.parse("20 * 4")

    assert_equal 5, @node.evaluate(@context)
  end

  def test_evaluate_when_division
    @node = Confuscript.parser.parse("5 / 4")

    assert_equal 20, @node.evaluate(@context)
  end
end