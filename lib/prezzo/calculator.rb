module Prezzo
  module Calculator
    def self.included(base)
      base.class_eval do
        base.include(Composable)
        base.include(Explainable)
      end
    end

    def initialize(context = {})
      @context = validated!(context)
    end

    def calculate
      raise "Calculate not implemented"
    end

    private

    attr_reader :context

    def validated!(context)
      raise "Empty Context" if context.nil?
      raise "Invalid Context" if context.respond_to?(:valid?) && !context.valid?

      context
    end
  end
end
