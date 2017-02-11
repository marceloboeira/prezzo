module Uber
  class RidePriceCalculator
    include Prezzo::Calculator
    include Prezzo::Composed

    composed_by base_fare: BaseFareCalculator,
                price_per_distance: PricePerDistanceCalculator,
                surge_multiplier: SurgeMultiplierCalculator

    def calculate
      (base_fare + price_per_distance) * surge_multiplier
    end
  end
end
