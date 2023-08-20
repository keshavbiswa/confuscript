require "test_helper"

class TestConsoleInputNode < Minitest::Test
  def setup
    @code = 'console.input("hello world")'
    @context = {}
  end

  def test_evaluate
    node = Confuscript.parser.parse(@code)

    assert_output("\"hello world\"\n") do
      node.evaluate(@context)
    end
  end
end
