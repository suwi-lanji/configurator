# Load the version file
Dir.chdir(File.expand_path(__dir__)) do
  require_relative 'lib/configurator/version'
end

Gem::Specification.new do |spec|
  spec.name          = 'config-to-laravel-migrations'
  spec.version       = Configurator::VERSION
  spec.authors       = ['Suwilanji Jack Chipofya']
  spec.email         = ['suwilanji@inongo.space']
  spec.summary       = 'Generate Laravel migrations from YAML or JSON config files.'
  spec.description   = 'A command-line tool to generate Laravel Eloquent migrations from YAML or JSON configuration files.'
  spec.homepage      = 'https://github.com/suwi-lanji/configurator'
  spec.license       = 'MIT'
  spec.files         = Dir['{bin,lib}/**/*', 'README.md']
  spec.bindir        = 'bin'
  spec.executables   = ['configurator']
  spec.require_paths = ['lib']
  spec.add_dependency 'thor', '~> 1.0'
  spec.add_dependency 'yaml', '~> 0.1'
  spec.add_dependency 'json', '~> 2.5'
  spec.add_development_dependency 'rspec', '~> 3.10'
end