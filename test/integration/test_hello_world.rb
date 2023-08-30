require "test_helper"

class TestHelloWorld < Minitest::Test
  def setup
    @input = File.read "test/fixtures/hello_world.notjs"
  end

  def test_hello_world
    output = <<~OUTPUT
      5
      Hello world!
    OUTPUT

    assert_output output do
      Confuscript.interpret(@input)
    end
  end
end