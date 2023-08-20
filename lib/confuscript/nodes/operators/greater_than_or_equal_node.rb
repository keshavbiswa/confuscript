module Confuscript
  module Nodes
    module Operators
      class GreaterThanOrEqualNode < Treetop::Runtime::SyntaxNode
        def evaluate(left, right)
          left >= right
        end
      end
    end
  end
end