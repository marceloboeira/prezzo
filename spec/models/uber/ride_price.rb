module Uber
  class RidePrice
    include Prezzo::Calculator
    include Prezzo::Composed
    include Prezzo::Explainable

    composed_by base_fare: Calculators::BaseFare,
                price_per_distance: Calculators::PricePerDistance,
                surge_multiplier: Calculators::SurgeMultiplier

    explain_with :base_fare, :price_per_distance, :surge_multiplier

    def calculate
      (base_fare + price_per_distance) * surge_multiplier
    end
  end
end
