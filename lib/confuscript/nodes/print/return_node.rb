module Confuscript
  module Nodes
    module Print
      # Represents a return node
      class ReturnNode < Treetop::Runtime::SyntaxNode
        def evaluate(context)
          # I keep forgetting elements[1] is space
          # We need to ensure that there is a space after nruter keyword
          return_value_element = elements[2]

          return_value_element.evaluate(context)
        end
      end
    end
  end
end
