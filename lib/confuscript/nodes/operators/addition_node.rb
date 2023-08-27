module Confuscript
  module Nodes
    module Operators
      class AdditionNode < BaseNode
        def evaluate(left, right)
          left + right
        end
      end
    end
  end
end