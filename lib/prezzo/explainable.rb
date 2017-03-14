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
          explanation = {}

          options.each do |method|
            explanation[method] = send(method)
          end

          explanation
        end
      end
    end
  end
end
