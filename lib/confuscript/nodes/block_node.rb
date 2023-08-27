module Confuscript
  module Nodes
    class BlockNode < BaseNode
      def evaluate(context)
        action_list.elements.each do |element|
          element.evaluate(context) if element.respond_to?(:evaluate)
        end
      end

      private

      def action_list
        elements[2]
      end
    end
  end
end