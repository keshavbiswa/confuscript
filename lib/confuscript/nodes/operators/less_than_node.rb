module Confuscript
  module Nodes
    module Operators
      class LessThanNode < BaseNode
        def evaluate(left, right)
          left < right
        end
      end
    end
  end
end