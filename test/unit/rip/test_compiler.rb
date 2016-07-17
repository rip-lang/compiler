require_relative '../../test_helper'

describe Rip::Compiler do
  let(:parse_tree) { Rip::Parser.load(:test, rip) }

  describe '#optimize' do
    describe 'basics' do
      let(:rip) { 'anawer = 42' }

      specify do
        assert_instance_of(Rip::Parser::Node, parse_tree)
        assert_instance_of(Rip::Parser::Node, Rip::Compiler.optimize(parse_tree))
      end

      specify { assert_equal(parse_tree, Rip::Compiler.optimize(parse_tree)) }
    end
  end
end
