module Confuscript
  module Nodes
    module Functions
      # Represents a FunctionCall node
      class FunctionCallNode < Treetop::Runtime::SyntaxNode
        def evaluate(context)
          function_name_element = elements[0]
          function_arguments_element = elements[3]

          function_name = function_name_element.text_value
          raise Confuscript::SyntaxError, "Function #{function_name} not defined" unless context[function_name]

          function_arguments = retrieve_arguments(function_arguments_element.elements, context)

          context[function_name].call(*function_arguments)
        end

        private

        # The normal structure for the elements is:
        ##
        # NumberNode offset=11, "5":
          # SyntaxNode offset=11, "5",
        # SyntaxNode offset=12, ", 2":
          # SyntaxNode+Arguments0 offset=12, ", 2" (value,space1,space2):
            # SyntaxNode offset=12, ""
            # SyntaxNode offset=12, ","
            # SyntaxNode offset=13, " ":
              # SyntaxNode offset=13, " "
            # NumberNode offset=14, "2":
              # SyntaxNode offset=14, "2"
        ## 
        # There is a nested structure for the arguments
        # This required a recursive function to retrieve the arguments
        # from the elements
        def retrieve_arguments(elements, context)
          elements.flat_map do |element|
            if element.respond_to?(:evaluate)
              element.evaluate(context)
            elsif element.elements
              retrieve_arguments(element.elements, context)
            else
              nil
            end
          end.compact
        end
      end
    end
  end
end
