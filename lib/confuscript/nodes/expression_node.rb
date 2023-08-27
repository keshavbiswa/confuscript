module Confuscript
  module Nodes
    class ExpressionNode < BaseNode
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