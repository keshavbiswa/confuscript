module Confuscript
  module Nodes
    class AssignmentNode < BaseNode
      def evaluate(context)
        # Store the value in the context using the variable's name as the key.
        # If the value is an arithmetic node, evaluate it first.
        # Otherwise, just evaluate the value.
        if respond_to?(:arithmetic)
          context[variable.text_value] = arithmetic.evaluate(context)
        elsif respond_to?(:value)
          context[variable.text_value] = value.evaluate(context)
        else respond_to?(:print_call)
          context[variable.text_value] = print_call.evaluate(context)
        end

        context[variable.text_value]
      end
    end
  end
end