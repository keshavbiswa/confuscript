require "test_helper"

class TestInitializeNode < Minitest::Test
  def setup
    @input = "null a;"
    @context = {}
  end

  def test_evaluate
    node = Confuscript.parser.parse(@input)
    result = node.evaluate(@context)

    assert @context.key?("a")
    assert_equal "a", result
  end
end
