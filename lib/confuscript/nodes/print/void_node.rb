module Confuscript
  module Nodes
    module Print
      # Represents a Void node
      class VoidNode < BaseNode
        def evaluate(context)
          # I keep forgetting elements[1] is space
          # We need to ensure that there is a space after void keyword
          void_value_element = elements[2]

          void_value_element.evaluate(context)
        end
      end
    end
  end
end
