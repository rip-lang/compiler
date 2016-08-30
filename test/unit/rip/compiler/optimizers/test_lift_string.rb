require_relative '../../../../test_helper'

describe Rip::Compiler::Optimizers::LiftString do
  let(:parse_tree) { Rip::Parser.load(:test, rip) }
  let(:actual) { Rip::Compiler::Optimizers::LiftString.apply(parse_tree).to_h(include_location: false) }

  describe 'root' do
    let(:rip) { ':foo' }

    let(:expected) do
      {
        type: :module,
        expressions: [
          {
            type: :assignment,
            lhs: { type: :reference, name: 'string-Zm9v' },
            rhs: {
              type: :string,
              characters: [
                { type: :character, data: 'f' },
                { type: :character, data: 'o' },
                { type: :character, data: 'o' }
              ]
            }
          },
          { type: :reference, name: 'string-Zm9v' }
        ]
      }
    end

    specify { assert_equal(expected, actual) }
  end

  describe 'nested' do
    let(:rip) { 'foos = [ :foo ]' }

    let(:expected) do
      {
        type: :module,
        expressions: [
          {
            type: :assignment,
            lhs: { type: :reference, name: 'string-Zm9v' },
            rhs: {
              type: :string,
              characters: [
                { type: :character, data: 'f' },
                { type: :character, data: 'o' },
                { type: :character, data: 'o' }
              ]
            }
          },
          {
            type: :assignment,
            lhs: { type: :reference, name: 'foos' },
            rhs: {
              type: :list,
              items: [
                { type: :reference, name: 'string-Zm9v' }
              ]
            }
          }
        ]
      }
    end

    specify { assert_equal(expected, actual) }
  end

  describe 'equivalent strings' do
    let(:rip) { ':foo; "foo"' }

    let(:expected) do
      {
        type: :module,
        expressions: [
          {
            type: :assignment,
            lhs: { type: :reference, name: 'string-Zm9v' },
            rhs: {
              type: :string,
              characters: [
                { type: :character, data: 'f' },
                { type: :character, data: 'o' },
                { type: :character, data: 'o' }
              ]
            }
          },
          { type: :reference, name: 'string-Zm9v' },
          { type: :reference, name: 'string-Zm9v' }
        ]
      }
    end

    specify { assert_equal(expected, actual) }
  end
end
