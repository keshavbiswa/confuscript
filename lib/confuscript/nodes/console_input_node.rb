module Confuscript
  module Nodes
    class ConsoleInputNode < BaseNode
      attr_accessor :string

      def evaluate(context)
        # Basically we're putsing the value
        # Not the best way to do this
        puts value.evaluate(context)
      end
    end
  end
end