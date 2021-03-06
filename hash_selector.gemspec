# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'hash_selector/version'

Gem::Specification.new do |spec|
  spec.name          = "hash-selector"
  spec.version       = HashSelector::VERSION
  spec.authors       = ["Peter Williams"]
  spec.email         = ["pezra@barelyenough.org"]
  spec.summary       = %q{Easily select values from deep inside hierarchical hashes.}
  spec.homepage      = "https://github.com/pezra/hash-selector"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.2"
end
