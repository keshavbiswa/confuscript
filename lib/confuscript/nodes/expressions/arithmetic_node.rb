module Confuscript
  module Nodes
    module Expressions
      class ArithmeticNode < BaseNode
        def evaluate(context)
          left_value = elements[0].evaluate(context)
          
          # For more than two operands, we need to check if the next elemnt
          # is a value or another arithmetic operation.
          if elements[4].is_a?(Confuscript::Nodes::Expressions::ArithmeticNode)
            right_value = elements[4].evaluate(context)
          else
            right_value = elements[4].evaluate(context)
          end

          operator.evaluate(left_value, right_value)
        end
      end
    end
  end
end