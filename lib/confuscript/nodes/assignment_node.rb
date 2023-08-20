module Confuscript
  module Nodes
    class AssignmentNode < Treetop::Runtime::SyntaxNode
      def evaluate(context)
        # Store the value in the context using the variable's name as the key.
        # If the value is an arithmetic node, evaluate it first.
        # Otherwise, just evaluate the value.
        if respond_to?(:arithmetic)
          context[variable.text_value] = arithmetic.evaluate(context)
        else
          context[variable.text_value] = value.evaluate(context)
        end

        context[variable.text_value]
      end
    end
  end
end