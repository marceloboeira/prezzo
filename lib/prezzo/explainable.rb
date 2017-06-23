module Prezzo
  module Explainable
    def self.included(base)
      base.class_eval do
        base.extend(ClassMethods)
      end
    end

    module ClassMethods
      def explain_with(*methods)
        define_method(:explain) do
          explanation = {
            total: calculate,
          }

          components = methods.each_with_object({}) do |method, acc|
            acc[method] = send(method)
          end

          explanation[:components] = components unless components.empty?

          explanation
        end
      end
    end
  end
end
