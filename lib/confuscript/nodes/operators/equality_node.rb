module Confuscript
  module Nodes
    module Operators
      class EqualityNode < BaseNode
        def evaluate(left, right)
          left == right
        end
      end
    end
  end
end