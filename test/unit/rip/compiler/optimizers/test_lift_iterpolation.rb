require_relative '../../../../test_helper'

describe Rip::Compiler::Optimizers::LiftInterpolation do
  let(:parse_tree) { Rip::Parser.load(:test, rip) }
  let(:actual) { Rip::Compiler::Optimizers::LiftInterpolation.apply(parse_tree).expressions.first.to_h(include_location: false) }

  describe 'empty string' do
    let(:rip) { '""' }

    let(:expected) do
      {
        type: :string,
        characters: []
      }
    end

    specify { assert_equal(expected, actual) }
  end

  describe 'string without interpolation' do
    let(:rip) { '"abc"' }

    let(:expected) do
      {
        type: :string,
        characters: [
          { type: :character, data: 'a' },
          { type: :character, data: 'b' },
          { type: :character, data: 'c' }
        ]
      }
    end

    specify { assert_equal(expected, actual) }
  end

  describe 'string with only interpolation' do
    let(:rip) { '"#{cd}"' }

    let(:expected) do
      {
        type: :invocation,
        callable: {
          type: :property_access,
          object: { type: :reference, name: 'cd' },
          property_name: 'to_string'
        },
        arguments: []
      }
    end

    specify { assert_equal(expected, actual) }
  end

  describe 'string with interpolation at start' do
    let(:rip) { '"#{cd}ef"' }

    let(:expected) do
      {
        type: :invocation,
        callable: {
          type: :property_access,
          object: {
            type: :invocation,
            callable: {
              type: :property_access,
              object: { type: :reference, name: 'cd' },
              property_name: 'to_string'
            },
            arguments: []
          },
          property_name: '+'
        },
        arguments: [
          {
            type: :string,
            characters: [
              { type: :character, data: 'e' },
              { type: :character, data: 'f' }
            ]
          }
        ]
      }
    end

    specify { assert_equal(expected, actual) }
  end

  describe 'string with interpolation at middle' do
    let(:rip) { '"ab#{cd}ef"' }

    let(:expected) do
      {
        type: :invocation,
        callable: {
          type: :property_access,
          object: {
            type: :invocation,
            callable: {
              type: :property_access,
              object: {
                type: :string,
                characters: [
                  { type: :character, data: 'a' },
                  { type: :character, data: 'b' }
                ]
              },
              property_name: '+'
            },
            arguments: [
              {
                type: :invocation,
                callable: {
                  type: :property_access,
                  object: { type: :reference, name: 'cd' },
                  property_name: 'to_string'
                },
                arguments: []
              }
            ]
          },
          property_name: '+'
        },
        arguments: [
          {
            type: :string,
            characters: [
              { type: :character, data: 'e' },
              { type: :character, data: 'f' }
            ]
          }
        ]
      }
    end

    specify { assert_equal(expected, actual) }
  end

  describe 'string with interpolation at end' do
    let(:rip) { '"ab#{cd}"' }

    let(:expected) do
      {
        type: :invocation,
        callable: {
          type: :property_access,
          object: {
            type: :string,
            characters: [
              { type: :character, data: 'a' },
              { type: :character, data: 'b' }
            ]
          },
          property_name: '+'
        },
        arguments: [
          {
            type: :invocation,
            callable: {
              type: :property_access,
              object: { type: :reference, name: 'cd' },
              property_name: 'to_string'
            },
            arguments: []
          }
        ]
      }
    end

    specify { assert_equal(expected, actual) }
  end

  describe 'string with multiple interpolations' do
    let(:rip) { '"#{ab}cd#{ef}"' }

    let(:expected) do
      {
        type: :invocation,
        callable: {
          type: :property_access,
          object: {
            type: :invocation,
            callable: {
              type: :property_access,
              object: {
                type: :invocation,
                callable: {
                  type: :property_access,
                  object: { type: :reference, name: 'ab' },
                  property_name: 'to_string'
                },
                arguments: []
              },
              property_name: '+'
            },
            arguments: [
              {
                type: :string,
                characters: [
                  { type: :character, data: 'c' },
                  { type: :character, data: 'd' }
                ]
              }
            ]
          },
          property_name: '+'
        },
        arguments: [
          {
            type: :invocation,
            callable: {
              type: :property_access,
              object: { type: :reference, name: 'ef' },
              property_name: 'to_string'
            },
            arguments: []
          }
        ]
      }
    end

    specify { assert_equal(expected, actual) }
  end

  describe 'regular expression with interpolation at middle' do
    let(:rip) { '/ab#{cd}ef/' }

    let(:expected) do
      {
        type: :invocation,
        callable: {
          type: :property_access,
          object: {
            type: :invocation,
            callable: {
              type: :property_access,
              object: {
                type: :regular_expression,
                pattern: [
                  { type: :character, data: 'a' },
                  { type: :character, data: 'b' }
                ]
              },
              property_name: '+'
            },
            arguments: [
              {
                type: :invocation,
                callable: {
                  type: :property_access,
                  object: {
                    type: :invocation,
                    callable: {
                      type: :property_access,
                      object: { type: :reference, name: 'cd' },
                      property_name: 'to_string'
                    },
                    arguments: []
                  },
                  property_name: 'to_regular_expression'
                },
                arguments: []
              }
            ]
          },
          property_name: '+'
        },
        arguments: [
          {
            type: :regular_expression,
            pattern: [
              { type: :character, data: 'e' },
              { type: :character, data: 'f' }
            ]
          }
        ]
      }
    end

    specify { assert_equal(expected, actual) }
  end
end
