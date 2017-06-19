module Prezzo
  module ParamsDSL
    def self.included(base)
      base.class_eval do
        base.extend(ClassMethods)
      end
    end

    module ClassMethods
      def param(name, &block)
        @params ||= []
        @params << name

        define_method(name) do
          cached_params[name] ||=
            begin
              value = context.fetch(name)
              value.class.class_eval(&block) if block
              value
            end
        end
      end

      def params
        @params
      end
    end

    def compile_params
      self.class.params&.reduce({}) do |acc, name|
        value = public_send(name)
        value = value.compile_params if value.respond_to?(:compile_params)
        acc[name] = value
        acc
      end
    end

    private

    def cached_params
      @cached_params ||= {}
    end
  end
end
