module Confuscript
  module Nodes
    module Values
      class BooleanNode < Treetop::Runtime::SyntaxNode
        def evaluate(context)
          # Return the value of the boolean
          # I don't know if this is even correct but since it's working
          # I'm going to leave it alone for now.
          text_value == "true"
        end
      end
    end
  end
end