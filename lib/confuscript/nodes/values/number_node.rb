module Confuscript
  module Nodes
    module Values
      class NumberNode < BaseNode
        def evaluate(_context)
          text_value.to_i
        end
      end
    end
  end
end