require "hanami-validations"

module Prezzo
  module Context
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

    def fetch(key, default = nil)
      if default.nil?
        attributes.fetch(key)
      else
        attributes.fetch(key, default) || default
      end
    end

    def attributes
      validation.output
    end

    private

    def validation
      @_validation ||= validate
    end
  end
end
