# frozen_string_literal: true

require "test_helper"

class TestConfuscript < Minitest::Test
  def setup
    @code = 'console.input("hello world");'
  end

  def test_successful_parse_and_interpret
    assert_output("\"hello world\"\n") do
      Confuscript.interpret(@code)
    end
  end

  def test_unsuccessful_parse
    assert_raises Confuscript::SyntaxError do
      Confuscript.interpret('console.wrong_syntax("hello world")')
    end
  end

  def test_empty_input
    assert_raises Confuscript::Error do
      Confuscript.interpret("")
    end
  end
end
