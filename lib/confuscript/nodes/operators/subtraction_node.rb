module Confuscript
  module Nodes
    module Operators
      class SubtractionNode < BaseNode
        def evaluate(left, right)
          left - right
        end
      end
    end
  end
end