# frozen_string_literal: true

require "test_helper"

class TestPrintDefinitionNode < Minitest::Test
  def setup
    @input = "print addNumbers(a, b) { void 1 + 3; };"
    @context = {}
  end

  def test_print_definition_parse
    node = Confuscript.parser.parse(@input)

    puts Confuscript.parser.failure_reason unless node

    assert node.is_a?(Confuscript::Nodes::Print::PrintDefinitionNode)
  end

  def test_print_definition_evaluate
    node = Confuscript.parser.parse(@input)

    node.evaluate(@context)

    assert @context.key?("addNumbers")
    assert @context["addNumbers"].is_a?(Proc)
  end

  def test_multiine_print_definition_evaluate
    input = <<~TEXT.chomp
      print addNumbers(a, b) {
        void 1 + 3;
      };
      TEXT

    node = Confuscript.parser.parse(input)

    node.evaluate(@context)

    assert @context.key?("addNumbers")
    assert @context["addNumbers"].is_a?(Proc)
  end
end
