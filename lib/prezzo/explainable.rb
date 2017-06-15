module Prezzo
  module Explainable
    def explain
      calculate

      components.reduce({}) do |acc, (name, component)|
        acc[name] = component.calculate
        acc
      end
    end
  end
end
