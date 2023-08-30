module Confuscript
  module Nodes
    module Print
      # Represents a print definition node
      class PrintDefinitionNode < BaseNode
        def evaluate(context)
          print_name = print_name_element.text_value
          print_arguments = retrieve_arguments(print_arguments_element.elements, context)
          print_body = print_body_element

          # I don't know I think I'll have to create a proc here
          # That will be used when printCallNode is evaluated
          print = proc do |*args|
            print_context = {}

            print_arguments.each_with_index do |argument, index|
              print_context[argument] = args[index]
            end

            print_body.evaluate(print_context)
          end

          # Some GuardRails to prevent overwriting
          raise Confuscript::SyntaxError, "Print #{print_name} already defined" if context[print_name]

          context[print_name] = print
        end

        def print_name_element
          elements[2]
        end

        def print_arguments_element
          elements[5]
        end

        def print_body_element
          elements[8]
        end

        # Since the VariableNodes are deeply nested
        # We need to deep search and fetch the VariableNodes
        # This method recursively does that
        # We have a same named method in PrintCallNode that does the same thing
        # Except it evaluates the value instead of returning the text_value
        # TODO: DRY out the code with PrintCallNode#retrieve_arguments
        def retrieve_arguments(elements, context)
          elements.flat_map do |element|
            if element.is_a?(Confuscript::Nodes::Values::VariableNode)
              element.text_value
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
