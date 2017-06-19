module Prezzo
  module ParamsDSL
    def self.included(base)
      base.class_eval do
        base.extend(ClassMethods)
      end
    end

    module ClassMethods
      def param(name, options = {}, &block)
        params << name

        define_method(name) do
          cached_params[name] ||=
            begin
              value = context.fetch(name, options[:default])
              value.class.class_eval(&block) if block
              value
            end
        end
      end

      def params
        @params ||= []
      end
    end

    def compile_params
      params = self.class.params.reduce({}) do |acc, name|
        value = public_send(name)
        value = value.compile_params if value.respond_to?(:compile_params)
        acc[name] = value
        acc
      end

      if @sub_context_name
        {
          @sub_context_name => params,
        }
      else
        params
      end
    end

    def sub_context(name)
      @sub_context_name = name
    end

    private

    def cached_params
      @cached_params ||= {}
    end
  end
end
