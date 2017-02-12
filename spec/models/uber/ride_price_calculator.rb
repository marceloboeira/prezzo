module Uber
  class RidePriceCalculator
    include Prezzo::Calculator
    include Prezzo::Composed
    include Prezzo::Explainable

    composed_by base_fare: BaseFareCalculator,
                price_per_distance: PricePerDistanceCalculator,
                surge_multiplier: SurgeMultiplierCalculator

    explain_with :base_fare, :price_per_distance, :surge_multiplier


    def calculate
      (base_fare + price_per_distance) * surge_multiplier
    end
  end
end
