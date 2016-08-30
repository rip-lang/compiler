module Rip::Compiler
  module Optimizers
  end
end

require_relative './optimizers/lift_interpolation'
require_relative './optimizers/lift_string'
