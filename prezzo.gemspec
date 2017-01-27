# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'prezzo/version'

Gem::Specification.new do |spec|
  spec.name          = "prezzo"
  spec.version       = Prezzo::VERSION
  spec.authors       = ["Marcelo Boeira"]
  spec.email         = ["me@marceloboeira.com"]
  spec.summary       = %q{Complex pricing models}
  spec.description   = %q{Complex pricing models}
  spec.homepage      = "http://github.com/marceloboeira/prezzo"
  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.13"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
