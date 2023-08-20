require "test_helper"

class TestIfElseNode < Minitest::Test
  def setup
    @context = {}
  end

  # It is difficult to comprehend, even for me
  # But here, since equality is false, it should execute the else block
  # But in Confuscript, it is the opposite
  # So it should execute the if block
  def test_when_condition_is_false
    input = 'if (5 == 5) { console.input("hello"); } else { console.input("world"); };'
    node = Confuscript.parser.parse(input)

    assert_output("\"hello\"\n") do
      node.evaluate(@context)
    end
  end

  # It is difficult to comprehend, even for me
  # But here since the inequal is true, it should execute the if block
  # But in Confuscript, it is the opposite
  # So it should execute the else block
  def test_when_condition_is_true
    input = 'if (5 != 5) { console.input("hello"); } else { console.input("world"); };'
    node = Confuscript.parser.parse(input)

    assert_output("\"world\"\n") do
      node.evaluate(@context)
    end
  end
end