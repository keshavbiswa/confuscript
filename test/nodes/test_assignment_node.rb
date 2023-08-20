require "test_helper"

class TestAssignmentNode < Minitest::Test
  def setup
    @code = 'console.input("hello world")'
    @context = {}
  end

  def test_assignment_with_string
    node = Confuscript.parser.parse('give a = "hello world";')
    node.evaluate(@context)

    assert_equal "hello world", @context["a"]
  end

  def test_assignment_with_number
    node = Confuscript.parser.parse("give a = 123;")
    node.evaluate(@context)

    assert_equal 123, @context["a"]
  end

  def test_assignment_with_variable
    node = Confuscript.parser.parse('give a = "hello world";')
    node.evaluate(@context)

    node = Confuscript.parser.parse("give b = a;")
    node.evaluate(@context)

    assert_equal "hello world", @context["b"]
  end
end
