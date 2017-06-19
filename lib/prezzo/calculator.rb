module Prezzo
  module Calculator
    def self.included(base)
      base.class_eval do
        base.include(ParamsDSL)
        base.include(ComponentsDSL)
        base.include(Explainable)
      end
    end

    def initialize(context = {})
      @context = context
    end

    def calculate
      @total ||= formula
    end

    def formula
      raise "Formula not implemented"
    end

    private

    attr_reader :context
  end
end
