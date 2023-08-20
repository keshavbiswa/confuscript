module Confuscript
  module Nodes
    class NumberNode < Treetop::Runtime::SyntaxNode
      def evaluate(_context)
        text_value.to_i
      end
    end
  end
end