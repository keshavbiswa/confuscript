require "test_helper"

class TestWhileLoop < Minitest::Test
  def setup
    @input = File.read "test/fixtures/while_loop.cfs"
  end

  def test_hello_world
    output = <<~OUTPUT
      Something going on here
      1
      This prints 5 times
      2
      This prints 5 times
      3
      This prints 5 times
      4
      This prints 5 times
      5
      This prints 5 times
      This prints once
    OUTPUT

    assert_output output do
      Confuscript.interpret(@input)
    end
  end
end