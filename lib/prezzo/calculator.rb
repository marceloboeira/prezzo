module Prezzo
  module Calculator
    def initialize(context = {})
      @context = validated!(context)
    end

    def calculate
      0
    end

    private

    def validated!(context)
      raise "Empty Context" if context.nil?
      raise "Invalid Context" if context.respond_to?(:valid?) && !context.valid?

      context
    end

    def context
      @context
    end
  end
end
