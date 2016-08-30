require 'base64'

module Rip::Compiler::Optimizers
  class LiftString
    attr_reader :mappings

    def initialize
      @mappings = {}
    end

    def apply(tree)
      reply = tree.traverse do |node|
        if node.string?
          data = node.characters.map(&:data).join('')
          name = "#{node.type}-#{Base64.strict_encode64(data)}"

          {
            location: tree.location,
            type: :reference,
            name: name
          }.tap do |reference|
            mappings[name] = [ reference, node ]
          end
        else
          node
        end
      end

      assignments = mappings.map do |_, (reference, node)|
        {
          location: tree.location,
          type: :assignment,
          lhs: reference,
          rhs: node
        }
      end

      reply.merge(expressions: assignments + reply.expressions)
    end

    def self.apply(tree)
      new.apply(tree)
    end
  end
end
