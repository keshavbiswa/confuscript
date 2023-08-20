require "test_helper"

class TestConsoleInputNode < Minitest::Test
  def setup
    @code = 'console.input("hello world")'
    @context = {}
  end

  def test_assignment_with_string
    node = Confuscript.parser.parse('give a = "hello world";')
    node.evaluate(@context)

    assert_equal "hello world", @context["a"]
  end
end
