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
            @inputs[arg] ||= context.fetch(arg)
          end
        end

        calculators.each do |name, klass|
          define_method(name) do
            @components[name] ||= klass.new(context)

            @components[name].calculate
          end
        end
      end
    end

    def initialize(context = {})
      @context = validated!(context)
      @components = {}
      @inputs = {}
    end

    def calculate
      @result ||= formula
    end

    def formula
      raise "Formula not implemented"
    end

    def explain
      explanation = {
        total: calculate
      }

      components = @components.reduce({}) do |acc, (name, component)|
        acc[name] = component.explain
        acc
      end

      explanation[:components] = components unless components.empty?

      inputs = @inputs.reduce({}) do |acc, (name, value)|
        acc[name] = value
        acc
      end

      explanation[:context] = inputs unless inputs.empty?

      explanation
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
