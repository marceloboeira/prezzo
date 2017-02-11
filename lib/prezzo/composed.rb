module Prezzo
  module Composed
    def self.included(base)
      base.class_eval do
        base.extend(ClassMethods)
      end
    end

    module ClassMethods
      def composed_by(options)
        @@__calculators = {}

        options.each do |name, klass|
          @@__calculators[name] = klass

          define_method(name) do
            @@__calculators[name].new(context).calculate
          end
        end
      end
    end
  end
end
