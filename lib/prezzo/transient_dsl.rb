module Prezzo
  module TransientDSL
    def self.included(base)
      base.class_eval do
        base.extend(ClassMethods)
      end
    end

    module ClassMethods
      def transient(name)
        transients << name

        define_method(name) do
          cached_transients[name] ||= yield
        end
      end

      def transients
        @transients ||= []
      end
    end

    def compile_transients
      self.class.transients.reduce({}) do |acc, name|
        public_send(name) # force transient cache
        acc[name] = cached_transients[name]
        acc
      end
    end

    private

    def cached_transients
      @cached_transients ||= {}
    end
  end
end
