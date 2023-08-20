module Confuscript
  module Nodes
    class StringNode < Treetop::Runtime::SyntaxNode
      attr_accessor :string_content

      def initialize(source, interval, elements = nil)
        super
        @string_content = nil
      end

      def string
        @string_content || super
      end

      def evaluate(context)
        # Return the inner string of the node
        string.text_value
      end
    end
  end
end