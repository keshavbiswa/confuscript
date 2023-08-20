module Confuscript
  module Nodes
    module Values
      class NumberNode < Treetop::Runtime::SyntaxNode
        def evaluate(_context)
          text_value.to_i
        end
      end
    end
  end
end