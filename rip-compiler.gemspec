require_relative './source/rip/compiler/about'

Gem::Specification.new do |spec|
  spec.name          = 'rip-compiler'
  spec.version       = Rip::Compiler::About.version
  spec.author        = 'Thomas Ingram'
  spec.license       = 'MIT'
  spec.summary       = 'Ruby compiler for Rip'
  spec.homepage      = 'http://www.rip-lang.org/'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.require_paths = [ 'source' ]

  spec.add_runtime_dependency 'rip-parser'

  spec.add_development_dependency 'minitest'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'pry-doc'
  spec.add_development_dependency 'rake'
end
