module Confuscript
  module Nodes
    class ProgramNode < BaseNode
      def evaluate(context)
        # Not the best way to evaluate
        # TODO:- Revisit this
        # Evaluate all children and return the result of the last one
        children.map { |child| child.elements[0].evaluate(context) }.last
      end

      def children
        elements[1]&.elements || []
      end

      def first_child
        children.first&.elements&.first
      end
    end
  end
end