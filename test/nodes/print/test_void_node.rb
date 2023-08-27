require "test_helper"

class TestVoidNode < Minitest::Test
  def setup
    @input = "void 5;"
    @context = {}
  end

  def test_void_node_parse
    node = Confuscript.parser.parse(@input)

    puts Confuscript.parser.failure_reason unless node

    assert node.is_a?(Confuscript::Nodes::Print::VoidNode)
  end

  def test_void_node_evaluate
    node = Confuscript.parser.parse(@input)

    result = node.evaluate(@context)

    assert_equal(5, result)
  end
end