module Confuscript
  module Nodes
    module Expressions
      class ParenthesizedNode < BaseNode
        def evaluate(context)
          elements[2].evaluate(context)
        end
      end
    end
  end
end
