require "hanami-validations"

module Prezzo
  module Context
    extend Forwardable

    def self.included(base)
      base.class_eval do
        base.include(Hanami::Validations)
      end
    end

    def valid?
      validation.success?
    end

    def errors
      validation.errors
    end

    delegate fetch: :attributes

    private

    def attributes
      validation.output
    end

    def validation
      @_validation ||= validate
    end
  end
end
