module Prezzo
  module Explainable
    def explain
      explanation = {
        total: calculate,
      }

      components = self.class.components&.reduce({}) do |acc, name|
        public_send(name) # force component cache
        acc[name] = cached_components[name].explain
        acc
      end
      explanation[:components] = components unless components.nil? || components.empty?

      context = self.class.params&.reduce({}) do |acc, name|
        acc[name] = public_send(name)
        acc
      end
      explanation[:context] = context unless context.nil? || context.empty?

      explanation
    end
  end
end
