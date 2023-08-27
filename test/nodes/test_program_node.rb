require "test_helper"

class TestProgramNode < Minitest::Test
  def setup
    @input = 'console.input("hello world");'
    @context = {}
  end

  def test_program_node_parse
    node = Confuscript.parser.parse(@input)

    puts Confuscript.parser.failure_reason unless node

    assert node.is_a?(Confuscript::Nodes::ProgramNode)
    assert node.child.is_a?(Confuscript::Nodes::ConsoleInputNode)
  end

  def test_program_node_evaluate
    node = Confuscript.parser.parse(@input)

    assert_output("\"hello world\"\n") do
      node.evaluate(@context)
    end
  end

  def test_raises_error_when_no_child
    node = Confuscript.parser.parse("")

    assert_raises Confuscript::SyntaxError do
      node.evaluate(@context)
    end
  end
end