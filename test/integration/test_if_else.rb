require "test_helper"

class TestIfElse < Minitest::Test
  def setup
    @input = File.read "test/fixtures/if_else.notjs"
  end

  def test_if_else
    output = <<~OUTPUT
      a is less than b
      a is less than b
    OUTPUT

    assert_output output do
      Confuscript.interpret(@input)
    end
  end
end