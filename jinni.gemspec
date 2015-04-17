# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'jinni/version'

Gem::Specification.new do |spec|
  spec.name          = "jinni"
  spec.version       = Jinni::VERSION
  spec.authors       = ["Andrew Monks"]
  spec.email         = ["a@monks.co"]

  spec.summary       = %q{unconventional genetics, aggressively metaprogrammed [hideous code use at your own risk]}
  spec.homepage      = "http://github.com/amonks/jinni"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]


  spec.add_development_dependency "bundler", "~> 1.9"
  spec.add_development_dependency "rake", "~> 10.0"
end
