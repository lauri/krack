# encoding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'krack/version'

Gem::Specification.new do |gem|
  gem.name          = "krack"
  gem.version       = Krack::VERSION
  gem.authors       = ["Kovalo"]
  gem.email         = ["team@kovalo.com"]
  gem.description   = "Simple JSON APIs on Rack"
  gem.summary       = gem.description
  gem.homepage      = "https://github.com/kovalo/krack"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_runtime_dependency 'rack', '~> 1.4.5'
  gem.add_runtime_dependency 'multi_json'

  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'minitest'
  gem.add_development_dependency 'rack-test'
end
