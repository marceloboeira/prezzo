module Prezzo
  module Explainable
    def explain
      explanation = {
        total: calculate,
      }

      components = cached_components.reduce({}) do |acc, (name, component)|
        acc[name] = component.calculate
        acc
      end
      explanation[:components] = components unless components.empty?

      params = cached_params.reduce({}) do |acc, (name, value)|
        acc[name] = value
        acc
      end
      explanation[:context] = params unless params.empty?

      explanation
    end
  end
end
