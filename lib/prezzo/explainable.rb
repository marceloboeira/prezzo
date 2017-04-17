module Prezzo
  module Explainable
    def self.included(base)
      base.class_eval do
        base.extend(ClassMethods)
      end
    end

    module ClassMethods
      def explain_with(*options)
        define_method(:explain) do
          options.each_with_object({}) do |method, explanation|
            explanation[method] = send(method)
          end
        end
      end
    end
  end
end
