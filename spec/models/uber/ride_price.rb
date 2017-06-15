module Uber
  class RidePrice
    include Prezzo::Calculator
    include Prezzo::Explainable

    component :base_fare, Calculators::BaseFare
    component :price_per_distance, Calculators::PricePerDistance
    component :surge_multiplier, Calculators::SurgeMultiplier

    explain_with :base_fare, :price_per_distance, :surge_multiplier

    def calculate
      (base_fare + price_per_distance) * surge_multiplier
    end
  end
end
