module Confuscript
  module Nodes
    class ArithmeticNode < Treetop::Runtime::SyntaxNode
      def evaluate(context)
        left_value = elements[0].evaluate(context)
        right_value = elements[4].evaluate(context)

        operator.evaluate(left_value, right_value)
      end
    end
  end
end