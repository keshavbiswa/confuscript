module Confuscript
  module Nodes
    class IfElseNode < BaseNode
      # Since the condition is inverse, we evaluate the 'else' block if the condition is true
      def evaluate(context)
        if if_clause.comparison.evaluate(context)
          else_clause.block.evaluate(context)
        else
          if_clause.block.evaluate(context)
        end
      end

      private

      def if_clause
        elements[0]
      end

      def else_clause
        elements[1]
      end
    end
  end
end
