module Confuscript
  module Nodes
    module Operators
      class MultiplicationNode < BaseNode
        def evaluate(left, right)
          left * right
        end
      end
    end
  end
end