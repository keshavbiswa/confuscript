# frozen_string_literal: true

require "bundler/gem_tasks"
require "rake/testtask"

Rake::TestTask.new(:test) do |t|
  t.libs << "test"
  t.libs << "lib"
  t.test_files = FileList["test/**/test_*.rb"]
end

GRAMMAR = "lib/confuscript/grammar.treetop"
COMPILED_GRAMMAR = "lib/confuscript/grammar.rb"

desc "Compile the Treetop grammar, replacing Object#extend with generated subclasses for Spinel"
task :grammar do
  require "treetop"
  Treetop::Compiler::GrammarCompiler.new.compile(GRAMMAR, COMPILED_GRAMMAR)

  node_classes = {}
  source = File.read(COMPILED_GRAMMAR).gsub(
    /(\w+) = instantiate_node\(([\w:]+),(.*)\)\n\s*\1\.extend\((\w+)\)\n/
  ) do
    var, klass, args, mod = Regexp.last_match.captures
    name = "#{klass.split("::").last}With#{mod}"
    definition = "  class #{name} < #{klass}\n    include #{mod}\n  end\n"
    raise "#{name} generated for two different base classes" if node_classes.fetch(name, definition) != definition

    node_classes[name] = definition
    "#{var} = instantiate_node(#{name},#{args})\n"
  end
  raise "#{COMPILED_GRAMMAR} still calls extend" if source.include?(".extend(")

  definitions = "module Confuscript\n#{node_classes.values.join("\n")}end\n\n"
  source.sub!(/^class ConfuscriptParser/) { "#{definitions}class ConfuscriptParser" } or
    raise "class ConfuscriptParser not found in #{COMPILED_GRAMMAR}"
  File.write(COMPILED_GRAMMAR, source)
end

require "rubocop/rake_task"

RuboCop::RakeTask.new

task default: %i[test rubocop]
