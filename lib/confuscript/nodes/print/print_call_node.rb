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

          print_arguments = retrieve_arguments(print_arguments_element, context)

          begin
            context[print_name].call(*print_arguments)
          rescue Confuscript::VoidEncountered => e
            e.value
          end
        end

        private

        # arguments is empty when omitted, otherwise elements are
        # [value, repetition of [space, ",", space, value]]
        def retrieve_arguments(arguments, context)
          return [] if arguments.empty?

          values = [arguments.elements[0]] + arguments.elements[1].elements.map(&:value)
          values.map { |value| value.evaluate(context) }
        end
      end
    end
  end
end
