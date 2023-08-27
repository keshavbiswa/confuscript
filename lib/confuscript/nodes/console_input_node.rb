module Confuscript
  module Nodes
    class ConsoleInputNode < BaseNode
      attr_accessor :string

      def evaluate(context)
        # For demonstration purposes,
        # we're just printing the inner string of console.input to the console.        puts value.evaluate(context)
      end
    end
  end
end