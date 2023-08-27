module Confuscript
  module Nodes
    module Loops
      # Represents a while_loop node
      class WhileNode < BaseNode
        def evaluate(context)
          comparison_node_element = elements[3]
          block_node_element = elements[6]
          
          while comparison_node_element.evaluate(context) == false
            block_node_element.evaluate(context)
          end
        end
      end
    end
  end
end
