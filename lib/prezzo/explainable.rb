module Prezzo
  module Explainable
    def self.included(base)
      base.class_eval do
        base.extend(ClassMethods)
      end
    end

    module ClassMethods
      def explain_with(*component_names, **options)
        @explained_components ||= {}
        component_names.each do |component_name|
          @explained_components[component_name] = options
        end
      end

      attr_reader :explained_components
    end

    def explain
      explained_components = self.class.explained_components || {}

      explanation = {
        total: calculate,
        components: {},
      }

      explained_components.each do |component, options|
        value = send(component)
        if self.class.respond_to?(:components) && self.class.components.include?(component)
          value = cached_components[component]
        end
        value = value.explain if value.respond_to?(:explain) && options.fetch(:resursive, true)
        value = value.calculate if value.respond_to?(:calculate)
        explanation[:components][component] = value
      end

      explanation
    end
  end
end
