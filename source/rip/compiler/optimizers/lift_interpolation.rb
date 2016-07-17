module Rip::Compiler::Optimizers
  class LiftInterpolation
    def self.apply(tree)
      tree.traverse do |node|
        case
        when node.regular_expression?
          expand(:regular_expression, :pattern, node) do |interpolation|
            Rip::Parser::Node.new(
              location: interpolation.location,
              type: :invocation,
              callable: {
                location: interpolation.location,
                type: :property_access,
                object: {
                  location: interpolation.location,
                  type: :invocation,
                  callable: {
                    location: interpolation.location,
                    type: :property_access,
                    object: interpolation,
                    property_name: 'to_string'
                  },
                  arguments: []
                },
                property_name: 'to_regular_expression'
              },
              arguments: []
            )
          end
        when node.string?
          expand(:string, :characters, node) do |interpolation|
            Rip::Parser::Node.new(
              location: interpolation.location,
              type: :invocation,
              callable: {
                location: interpolation.location,
                type: :property_access,
                object: interpolation,
                property_name: 'to_string'
              },
              arguments: []
            )
          end
        else
          node
        end
      end
    end

    def self.expand(type, parts_key, node, &interpolate)
      parts = node[parts_key]

      parts.inject([]) do |groups, part|
        if groups.count.zero?
          [ [ part ] ]
        else
          last_group = groups.last

          if last_group.first.character? && part.character?
            [ *groups[0..-2], last_group + [ part ] ]
          else
            [ *groups, [ part ] ]
          end
        end
      end.map do |group|
        if group.first.interpolation?
          interpolate.call(group.first.expression)
        else
          Rip::Parser::Node.new(location: group.first.location, type: type, parts_key => group)
        end
      end.inject do |expression, sub_expression|
        Rip::Parser::Node.new(
          location: sub_expression.location,
          type: :invocation,
          callable: {
            location: sub_expression.location,
            type: :property_access,
            object: expression,
            property_name: '+'
          },
          arguments: [ sub_expression ]
        )
      end || Rip::Parser::Node.new(location: (parts.first || node).location, type: type, parts_key => parts)
    end
  end
end
