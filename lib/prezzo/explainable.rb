module Prezzo
  module Explainable
    def self.included(base)
      base.class_eval do
        base.extend(ClassMethods)
      end
    end

    module ClassMethods
      def explain_with(*component_names)
        define_method(:explain) do
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
  end
end
