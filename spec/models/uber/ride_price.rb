module Uber
  class RidePrice
    include Prezzo::Calculator
    include Prezzo::Explainable

    component :base_fare, Calculators::BaseFare
    component :price_per_distance, Calculators::PricePerDistance
    component :surge_multiplier, Calculators::SurgeMultiplier

    def calculate
      (base_fare + price_per_distance) * surge_multiplier
    end
  end
end
