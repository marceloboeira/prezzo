module Prezzo
  module Explainable
    def self.included(base)
      base.class_eval do
        base.extend(ClassMethods)
      end
    end

    module ClassMethods
      def explain_with(*component_names)
        @explained_component_names ||= []
        @explained_component_names += component_names
      end

      attr_reader :explained_component_names
    end

    def explain
      component_names = self.class.explained_component_names || []

      explanation = {
        total: calculate,
      }

      components = component_names.each_with_object({}) do |component, acc|
        value = send(component)
        if self.class.respond_to?(:components) && self.class.components.include?(component)
          value = cached_components[component]
        end
        value = value.explain if value.respond_to?(:explain)
        value = value.calculate if value.respond_to?(:calculate)
        acc[component] = value
      end

      explanation[:components] = components unless components.empty?

      explanation
    end
  end
end
