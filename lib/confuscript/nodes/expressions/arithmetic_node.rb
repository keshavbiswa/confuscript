module Confuscript
  module Nodes
    module Expressions
      class ArithmeticNode < BaseNode
        # elements: [first_operand, repetition of [space, operator, space, operand]]
        def evaluate(context)
          elements[1].elements.reduce(elements[0].evaluate(context)) do |left, step|
            step.elements[1].evaluate(left, step.elements[3].evaluate(context))
          end
        end
      end
    end
  end
end
