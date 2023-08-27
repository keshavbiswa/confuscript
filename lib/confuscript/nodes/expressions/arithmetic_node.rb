module Confuscript
  module Nodes
    module Expressions
      class ArithmeticNode < BaseNode
        def evaluate(context)
          left_value = elements[0].evaluate(context)
          right_value = elements[4].evaluate(context)

          operator.evaluate(left_value, right_value)
        end
      end
    end
  end
end