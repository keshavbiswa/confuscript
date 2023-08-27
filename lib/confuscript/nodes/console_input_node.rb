module Confuscript
  module Nodes
    class ConsoleInputNode < BaseNode
      attr_accessor :string

      def evaluate(_context)
        # For demonstration purposes, we're just printing the inner string of console.input to the console.
        # In a real-world scenario, we might do more here, like adding the output to the context.
        puts string.text_value
      end
    end
  end
end