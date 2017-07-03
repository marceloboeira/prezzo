module Prezzo
  module Composable
    def self.included(base)
      base.class_eval do
        base.extend(ClassMethods)
      end
    end

    module ClassMethods
      def composed_by(options)
        options.each do |name, klass|
          components << name

          define_method(name) do
            cached_components[name] ||= klass.new(context)

            cached_components[name].calculate
          end
        end
      end

      def components
        @components ||= []
      end
    end

    private

    def cached_components
      @cached_components ||= {}
    end
  end
end
