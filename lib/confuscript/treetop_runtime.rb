# frozen_string_literal: true

# Adapted from the treetop 1.6.12 runtime. Copyright (c) 2007 Nathan Sobo. MIT License.

class String
  def column_of(index)
    return 1 if index.zero?

    newline_index = rindex("\n", index - 1)
    newline_index ? index - newline_index : index + 1
  end

  def line_of(index)
    self[0...index].count("\n") + 1
  end
end

module Treetop
  module Runtime
    class SyntaxNode
      attr_reader :input, :interval

      def initialize(input, interval, elements = nil)
        @input = input
        @interval = interval
        @elements = elements
      end

      def elements
        return @elements if terminal?

        last_element = nil
        @elements = @elements.map do |element|
          if element == true
            index = last_element ? last_element.interval.last : interval.first
            element = SyntaxNode.new(input, index...(index + 1))
          end
          last_element = element
        end
      end

      def terminal?
        @elements.nil?
      end

      def text_value
        input[interval]
      end

      def empty?
        interval.first == interval.last && interval.exclude_end?
      end
    end

    class CompiledParser
      include Treetop::Runtime

      attr_reader :input, :index, :max_terminal_failure_index

      def parse(input)
        prepare_to_parse(input)
        result = _nt_program
        return result if index == input_length

        terminal_parse_failure("<END OF INPUT>", true) if index > max_terminal_failure_index
        nil
      end

      def failure_reason
        return nil if @terminal_failures.empty?

        at = max_terminal_failure_index
        expected = @terminal_failures.map do |_, expected_string, unexpected|
          (unexpected ? "something other than " : "") + expected_string
        end.uniq
        "Expected #{expected.size == 1 ? expected[0] : "one of #{expected.join(", ")}"}" \
          " at line #{input.line_of(at)}, column #{input.column_of(at)} (byte #{at + 1})" +
          (at.positive? ? " after #{input[index...at]}" : "")
      end

      protected

      attr_reader :node_cache, :input_length

      def prepare_to_parse(input)
        @input = input
        @chars = input.chars
        @input_length = @chars.size
        @index = 0
        @node_cache = Hash.new { |hash, key| hash[key] = {} }
        @regexps = {}
        @terminal_failures = []
        @max_terminal_failure_index = 0
      end

      def instantiate_node(node_type, input, interval, elements = nil)
        node_type.new(input, interval, elements)
      end

      def has_terminal?(terminal, mode, index)
        if mode == :regexp
          char = @chars[index]
          !char.nil? && terminal.match?(char) && 1
        else
          size = terminal.size
          (0...size).all? { |offset| @chars[index + offset] == terminal[offset] } && size
        end
      end

      def terminal_parse_failure(expected_string, unexpected = false)
        return nil if index < max_terminal_failure_index

        if index > max_terminal_failure_index
          @max_terminal_failure_index = index
          @terminal_failures = []
        end
        @terminal_failures << [index, expected_string, unexpected]
        nil
      end
    end
  end
end
