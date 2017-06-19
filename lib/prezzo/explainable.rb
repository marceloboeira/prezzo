module Prezzo
  module Explainable
    def explain
      explanation = {
        total: calculate,
      }

      components = compile_components
      explanation[:components] = components unless components.nil? || components.empty?

      context = compile_params
      explanation[:context] = context unless context.nil? || context.empty?

      explanation
    end
  end
end
