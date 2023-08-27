require "test_helper"

class TestWhileNode < Minitest::Test
  def setup
    @input = "while (a != 5) { a = a - 1; };"
    @context = { "a" => 0 }
  end

  def test_while_node_parse
    node = Confuscript.parser.parse(@input)

    puts Confuscript.parser.failure_reason unless node

    assert node.first_child.is_a?(Confuscript::Nodes::Loops::WhileNode)
  end

  def test_while_node_evaluate
    node = Confuscript.parser.parse(@input)

    node.evaluate(@context)

    assert_equal(5, @context["a"])
  end

  def test_multiline_while_node_evaluate
    input = <<~TEXT.chomp
      while (a != 5) {
        a = a - 1;
      };
    TEXT

    node = Confuscript.parser.parse(input)

    node.evaluate(@context)

    assert_equal(5, @context["a"])
  end
end