module Prezzo
  module Composable
    def self.included(base)
      base.class_eval do
        base.extend(ClassMethods)
      end
    end

    module ClassMethods
      def param(name)
        define_method(name) do
          cached_params[name] ||= context.fetch(name)
        end
      end

      def component(name, klass)
        define_method(name) do
          cached_components[name] ||= klass.new(context)

          cached_components[name].calculate
        end
      end
    end

    private

    def cached_components
      @cached_components ||= {}
    end

    def cached_params
      @cached_params ||= {}
    end
  end
end
