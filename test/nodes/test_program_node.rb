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
    assert node.first_child.is_a?(Confuscript::Nodes::ConsoleInputNode)
  end

  def test_program_node_evaluate
    node = Confuscript.parser.parse(@input)

    assert_output("hello world\n") do
      node.evaluate(@context)
    end
  end
end