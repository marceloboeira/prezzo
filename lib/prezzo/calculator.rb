module Prezzo
  module Calculator
    class ContextWrapper
      def initialize(context, *args)
        @context = context
        @args = args
        @cache = {}
      end

      def method_missing(arg)
        super unless @args.include?(arg)

        @cache[arg] ||= @context.fetch(arg)
      end

      def explain
        @cache.reduce({}) do |acc, (key, value)|
          acc[key] = value
          acc
        end
      end
    end

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

        calculators.each do |name, value|
          case value
          when Array
            define_method(name) do
              wrapper = ContextWrapper.new(context.fetch(name), *value)
              @inputs[name] ||= wrapper
            end
          else
            klass = value
            define_method(name) do
              @components[name] ||= klass.new(context)

              @components[name].calculate
            end
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
        if value.is_a?(ContextWrapper)
          acc[name] = value.explain
        else
          acc[name] = value
        end

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
