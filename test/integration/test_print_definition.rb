require "test_helper"

class TestPrintDefinition < Minitest::Test
  def setup
    @input = File.read "test/fixtures/print_definition.notjs"
  end

  def test_print_definition
    output = <<~OUTPUT
      This prints the sum of two numbers.
      The result is:
      -1
    OUTPUT

    assert_output(output) do
      Confuscript.interpret(@input)
    end 
  end
end