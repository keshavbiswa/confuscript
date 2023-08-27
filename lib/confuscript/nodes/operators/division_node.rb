module Confuscript
  module Nodes
    module Operators
      class DivisionNode < BaseNode
        def evaluate(left, right)
          left / right
        end
      end
    end
  end
end