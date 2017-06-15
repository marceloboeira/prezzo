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

      explanation
    end
  end
end
