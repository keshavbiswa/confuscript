require "test_helper"

class TestBooleanNode < Minitest::Test
  def setup
    @value = "false"
    @context = {}
    @interval = 0..@value.length
  end

  def test_evaluate
    node = Confuscript::Nodes::Values::BooleanNode.new(@value, @interval)
    result = node.evaluate(@context)

    assert_equal false, result
  end

  def test_parsing
    node = Confuscript.parser.parse("null a = false;")
    node.evaluate(@context)

    assert_equal false, @context["a"]
  end
end
