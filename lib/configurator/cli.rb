require 'thor'
require 'configurator/generator'
require 'configurator/version'
module Configurator
  class CLI < Thor
    desc "generate FILE OUTPUT_DIR", "Generate Laravel migrations from a YAML or JSON file"
    def generate(file, output_dir)
      Generator.new(file, output_dir).generate_migrations
    end

    desc "version", "Print the version"
    def version
      puts Configurator::VERSION
    end
  end
end