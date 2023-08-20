module Confuscript
  module Nodes
    class AssignmentNode < Treetop::Runtime::SyntaxNode
      def evaluate(context)
        # Store the value in the context using the variable's name as the key.
        context[variable.text_value] = value.evaluate(context)
      end
    end
  end
end