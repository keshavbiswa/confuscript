module Confuscript
  module Nodes
    class ExpressionNode < Treetop::Runtime::SyntaxNode
      def evaluate(context)
        if respond_to?(:arithmetic)
          arithmetic.evaluate(context)
        elsif respond_to?(:comparison)
          comparison.evaluate(context)
        else
          value.evaluate(context)
        end
      end
    end
  end
end