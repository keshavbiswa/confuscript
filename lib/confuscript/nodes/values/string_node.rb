module Confuscript
  module Nodes
    module Values
      class StringNode < BaseNode
        def evaluate(context)
          # Return the inner string of the node
          text_value[1..-2] # Remove the quotes
        end
      end
    end
  end
end