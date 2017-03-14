module Prezzo
  module Composed
    def self.included(base)
      base.class_eval do
        base.extend(ClassMethods)
      end
    end

    module ClassMethods
      def composed_by(options)
        options.each do |name, klass|
          options[name] = klass

          define_method(name) do
            options[name].new(context).calculate
          end
        end
      end
    end
  end
end
