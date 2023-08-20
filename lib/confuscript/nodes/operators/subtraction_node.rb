module Confuscript
  module Nodes
    module Operators
      class SubtractionNode < Treetop::Runtime::SyntaxNode
        def evaluate(left, right)
          left - right
        end
      end
    end
  end
end