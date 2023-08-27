module Confuscript
  module Nodes
    module Functions
      # Represents a function definition node
      class FunctionDefinitionNode < Treetop::Runtime::SyntaxNode
        def evaluate(context)
          function_name_element = elements[2]
          function_arguments_element = elements[5]
          function_body_element = elements[8]


          function_name = function_name_element.text_value
          function_arguments = function_arguments_element.elements.map(&:text_value)
          function_body = function_body_element

          # I don't know I think I'll have to create a proc here
          # That will be used when functionCallNode is evaluated
          function = proc do |*args|
            function_context = {}

            function_arguments.each_with_index do |argument, index|
              function_context[argument] = args[index]
            end

            function_body.evaluate(function_context)

            function_context
          end

          # Some GuardRails to prevent overwriting
          raise Confuscript::SyntaxError, "Function #{function_name} already defined" if context[function_name]

          context[function_name] = function
        end
      end
    end
  end
end
