module Confuscript
  module Nodes
    module Print
      # Represents a print definition node
      class PrintDefinitionNode < BaseNode
        def evaluate(context)
          print_name = print_name_element.text_value
          print_arguments = print_arguments_element.elements.map(&:text_value)
          print_body = print_body_element

          # I don't know I think I'll have to create a proc here
          # That will be used when printCallNode is evaluated
          print = proc do |*args|
            print_context = {}

            print_arguments.each_with_index do |argument, index|
              print_context[argument] = args[index]
            end

            print_body.evaluate(print_context)

            print_context
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
      end
    end
  end
end
