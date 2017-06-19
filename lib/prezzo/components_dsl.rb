module Prezzo
  module ComponentsDSL
    def self.included(base)
      base.class_eval do
        base.extend(ClassMethods)
      end
    end

    module ClassMethods
      def component(name, klass, sub_context_name = nil)
        @components ||= []
        @components << name

        define_method(name) do
          cached_components[name] ||=
            begin
              c = sub_context_name ? context.fetch(sub_context_name) : context

              instance = klass.new(c)
              instance.sub_context(sub_context_name) if sub_context_name
              instance
            end

          cached_components[name].calculate
        end
      end

      def components
        @components
      end
    end

    def compile_components
      self.class.components&.reduce({}) do |acc, name|
        public_send(name) # force component cache
        acc[name] = cached_components[name].explain
        acc
      end
    end

    private

    def cached_components
      @cached_components ||= {}
    end
  end
end
