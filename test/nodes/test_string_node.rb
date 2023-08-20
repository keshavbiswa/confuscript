require "test_helper"

class TestStringNode < Minitest::Test
  def setup
    @string = "hello world"
    @context = {}
  end

  def test_evaluate
    node = Confuscript::Nodes::StringNode.new(nil, nil)
    mock_string = Struct.new(:text_value).new(@string)
    node.string_content = mock_string

    result = node.evaluate({})
    assert_equal "hello world", result
  end
end
