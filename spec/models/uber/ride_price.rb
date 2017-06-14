module Uber
  class RidePrice
    include Prezzo::Calculator

    composed_by origin: [:location_factor],
                base_fare: Calculators::BaseFare,
                price_per_distance: Calculators::PricePerDistance,
                surge_multiplier: Calculators::SurgeMultiplier

    def formula
      ((base_fare + price_per_distance) * origin.location_factor * surge_multiplier).round(2)
    end
  end
end
