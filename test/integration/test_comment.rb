require "test_helper"

class TestComment < Minitest::Test
  def test_single_line_comment
    input = File.read "test/fixtures/single_line_comment.notjs"
    assert_output "" do
      Confuscript.interpret("\\ This is a comment\n")
    end 
  end

  def test_inline_comment
    assert_output("hello world\n") do
      Confuscript.interpret("console.input(\"hello world\");\\ This is a comment\n")
    end
  end
end