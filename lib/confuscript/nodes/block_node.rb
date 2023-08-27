module Confuscript
  module Nodes
    class BlockNode < BaseNode
      def evaluate(context)
        action_lists.each do |action|
          element = action.elements.first
          element.evaluate(context) if element.respond_to?(:evaluate)
        end
      end

      private

      # The block before and after the { and } respectively
      # This keeps on changing everytime I change the grammar
      # Will need to revisit this again
      def action_lists
        elements[2].elements
      end
    end
  end
end