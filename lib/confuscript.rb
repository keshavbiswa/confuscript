# frozen_string_literal: true

require "treetop"

require_relative "confuscript/version"
require_relative "confuscript/nodes/console_input_node"
require_relative "confuscript/nodes/string_node"
require_relative "confuscript/nodes/assignment_node"
require_relative "confuscript/nodes/variable_node"
require_relative "confuscript/nodes/number_node"
require_relative "confuscript/nodes/initialization_node"

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
