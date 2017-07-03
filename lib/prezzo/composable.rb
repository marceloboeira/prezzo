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
          define_method(name) do
            klass.new(context).calculate
          end
        end
      end
    end
  end
end
