module Prezzo
  module Explainable
    def self.included(base)
      base.class_eval do
        base.extend(ClassMethods)
      end
    end

    module ClassMethods
      def explain_with(*options)
        @@_methods = options

        define_method(:explain) do
          explanation = {}

          @@_methods.each do |method|
            explanation[method] = send(method)
          end

          explanation
        end
      end
    end
  end
end
