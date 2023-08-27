module Confuscript
  module Nodes
    class ProgramNode < BaseNode
      def evaluate(context)
        raise Confuscript::SyntaxError, "There is no program to evaluate." unless child

        child.evaluate(context)
      end

      def child
        elements[1].elements[0]
      end
    end
  end
end