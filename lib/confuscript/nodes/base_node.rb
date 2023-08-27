module Confuscript
  module Nodes
    class BaseNode < Treetop::Runtime::SyntaxNode
      def find_node(type)
        self.elements.find { |element| element.is_a?(type) }
      end
    end
  end
end