module Prezzo
  module Calculator
    def initialize(context = {})
      @context = context
    end

    def calculate
      raise "Calculate not implemented"
    end

    private

    attr_reader :context
  end
end
