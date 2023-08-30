module Confuscript
  module Nodes
    class BlockNode < BaseNode
      def evaluate(context)
        actions = []
        action_lists.each do |action|
          element = action.elements.first
          actions << element.evaluate(context) if element.respond_to?(:evaluate)
        end

        actions.last
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