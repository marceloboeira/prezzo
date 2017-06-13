module Prezzo
  module Calculator
    def self.included(base)
      base.class_eval do
        base.extend(ClassMethods)
      end
    end

    module ClassMethods
      def composed_by(*args)
        calculators = args.last.is_a?(Hash) ? args.pop : {}

        args.each do |arg|
          define_method(arg) do
            context.fetch(arg)
          end
        end

        calculators.each do |name, klass|
          define_method(name) do
            klass.new(context).calculate
          end
        end
      end
    end

    def initialize(context = {})
      @context = validated!(context)
    end

    def calculate
      raise "Calculate not implemented"
    end

    private

    attr_reader :context

    def validated!(context)
      raise "Empty Context" if context.nil?
      raise "Invalid Context" if context.respond_to?(:valid?) && !context.valid?

      context
    end
  end
end
