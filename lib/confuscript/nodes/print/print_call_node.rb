module Confuscript
  module Nodes
    module Print
      # Represents a PrintCall node
      class PrintCallNode < BaseNode
        def evaluate(context)
          print_name_element = elements[0]
          print_arguments_element = elements[3]

          print_name = print_name_element.text_value
          raise Confuscript::SyntaxError, "Print #{print_name} not defined" unless context[print_name]

          print_arguments = retrieve_arguments(print_arguments_element.elements, context)

          begin
            context[print_name].call(*print_arguments)
          rescue Confuscript::VoidEncountered => e
            e.value
          end
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
        # This required a recursive print to retrieve the arguments
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
