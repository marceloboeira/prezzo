module Prezzo
  module Composable
    def self.included(base)
      base.class_eval do
        base.extend(ClassMethods)
      end
    end

    module ClassMethods
      def component(name, klass)
        define_method(name) do
          components[name] ||= klass.new(context)

          components[name].calculate
        end
      end
    end

    private

    def components
      @components ||= {}
    end
  end
end
