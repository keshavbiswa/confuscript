module Confuscript
  module Nodes
    class StringNode < Treetop::Runtime::SyntaxNode
      def evaluate(context)
        # Return the inner string of the node
        text_value[1..-2] # Remove the quotes
      end
    end
  end
end