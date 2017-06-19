module Prezzo
  class Context
    include ParamsDSL

    def initialize(attributes)
      @attributes = attributes
    end

    def fetch(key)
      value = @attributes.fetch(key)

      if value.is_a?(Hash)
        Class.new(Context).new(value)
      else
        value
      end
    end

    def context
      self
    end
  end
end
