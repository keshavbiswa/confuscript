module Confuscript
  module Nodes
    module Values
      class StringNode < BaseNode
        def evaluate(context)
          # Return the inner string of the node
          text_value[1..-3] # Remove the quotes (begin with double quote, end with two single quotes)
        end
      end
    end
  end
end
