# frozen_string_literal: true

require "treetop"

require_relative "confuscript/version"

require_relative "confuscript/nodes/console_input_node"
require_relative "confuscript/nodes/initialization_node"
require_relative "confuscript/nodes/assignment_node"
require_relative "confuscript/nodes/expression_node"
require_relative "confuscript/nodes/if_else_node"
require_relative "confuscript/nodes/block_node"

# Expressions
require_relative "confuscript/nodes/expressions/arithmetic_node"
require_relative "confuscript/nodes/expressions/comparison_node"

# Values
require_relative "confuscript/nodes/values/variable_node"
require_relative "confuscript/nodes/values/string_node"
require_relative "confuscript/nodes/values/number_node"
require_relative "confuscript/nodes/values/boolean_node"

# Operators
require_relative "confuscript/nodes/operators/addition_node"
require_relative "confuscript/nodes/operators/subtraction_node"
require_relative "confuscript/nodes/operators/multiplication_node"
require_relative "confuscript/nodes/operators/division_node"
require_relative "confuscript/nodes/operators/equality_node"
require_relative "confuscript/nodes/operators/non_equality_node"
require_relative "confuscript/nodes/operators/greater_than_node"
require_relative "confuscript/nodes/operators/less_than_node"
require_relative "confuscript/nodes/operators/greater_than_or_equal_node"
require_relative "confuscript/nodes/operators/less_than_or_equal_node"


module Confuscript
  class Error < StandardError; end
  class SyntaxError < Error; end

  def self.parser
    @parser ||= if File.file?("#{File.dirname(__FILE__)}/confuscript/grammar.rb")
                  # Take compiled one
                  require_relative "grammar"
                else
                  # Else compile and load
                  Treetop.load "#{File.dirname(__FILE__)}/confuscript/grammar.treetop"
                  ConfuscriptParser.new
                end
  end

  def self.interpret(code)
    ast = parser.parse(code)

    # Check if parsing was successful
    raise SyntaxError, parser.failure_reason if ast.nil?

    # Create a new context
    context = {}

    # Evaluate the AST
    ast.evaluate(context)

    context
  end
end
