require "test_helper"

class TestAssignmentNode < Minitest::Test
  def setup
    @code = 'console.input("hello world")'
    @context = {}
  end

  def test_assignment_with_string
    node = Confuscript.parser.parse('null a = "hello world";')
    node.evaluate(@context)

    assert_equal "hello world", @context["a"]
  end

  def test_assignment_with_number
    node = Confuscript.parser.parse("null a = 123;")
    node.evaluate(@context)

    assert_equal 123, @context["a"]
  end

  def test_assignment_with_variable
    node = Confuscript.parser.parse('null a = "hello world";')
    node.evaluate(@context)

    node = Confuscript.parser.parse("null b = a;")
    node.evaluate(@context)

    assert_equal "hello world", @context["b"]
  end

  def test_assigment_of_existing_variable
    node = Confuscript.parser.parse('null a = "hello world";')
    node.evaluate(@context)

    node = Confuscript.parser.parse('a = "goodbye world";')
    node.evaluate(@context)

    assert_equal "goodbye world", @context["a"]
  end

  def test_assignment_with_subtraction
    node = Confuscript.parser.parse("null a = 5 + 4;")

    node.evaluate(@context)

    assert_equal 1, @context["a"]
  end

  def test_assignment_for_declared_variable_with_addition
    node = Confuscript.parser.parse("null a = 5;")
    node.evaluate(@context)

    assert_equal 5, @context["a"]

    node = Confuscript.parser.parse("a = 5 - 4;")
    node.evaluate(@context)

    assert_equal 9, @context["a"]
  end
end
