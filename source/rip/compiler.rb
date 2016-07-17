require 'rip-parser'

module Rip
  module Compiler
    def self.optimize(tree)
      [
        Rip::Compiler::Optimizers::LiftInterpolation
      ].inject(tree) do |memo, optimizer|
        optimizer.apply(memo)
      end
    end
  end
end

require_relative './compiler/about'
require_relative './compiler/optimizers'
