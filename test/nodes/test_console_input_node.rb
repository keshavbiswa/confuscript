# frozen_string_literal: true

require "test_helper"

class TestConsoleInputNode < Minitest::Test
  def setup
    @hello_world = '"hello world"'
    @code = "console.input(#{@hello_world})"

    @context = {}
  end

  def test_console_input_evaluate
    string_node = Confuscript::Nodes::Values::StringNode.new(@hello_world, 0..@hello_world.length)
    node = Confuscript::Nodes::ConsoleInputNode.new(@code, 0..@code.length)
    node.string = string_node

    assert_output("\"hello world\"\n") do
      node.evaluate(@context)
    end
  end
end
