module Uber
  class RidePriceCalculator
    include Prezzo::Calculator
    include Prezzo::Composed

    composed_by base_fare: BaseFareCalculator,
                price_per_distance: PricePerDistanceCalculator,
                additional_per_demand: AdditionalPerDemandCalculator

    def calculate
      base_fare + price_per_distance + additional_per_demand
    end
  end
end
