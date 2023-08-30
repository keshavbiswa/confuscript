module Confuscript
  module Nodes
    class BaseNode < Treetop::Runtime::SyntaxNode
      def find_node(type)
        return self if self.is_a?(type)
        
        self.elements.find { |element| element.is_a?(type) }
      end
    end
  end
end