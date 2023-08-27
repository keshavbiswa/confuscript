module Confuscript
  module Nodes
    module Values
      class VariableNode < BaseNode
        def evaluate(context)
          # Return the value of the variable from the context
          context[text_value]
        end
      end
    end
  end
end
