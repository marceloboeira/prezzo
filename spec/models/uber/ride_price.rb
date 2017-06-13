module Uber
  class RidePrice
    include Prezzo::Calculator

    composed_by base_fare: Calculators::BaseFare,
                price_per_distance: Calculators::PricePerDistance,
                surge_multiplier: Calculators::SurgeMultiplier

    def formula
      (base_fare + price_per_distance) * surge_multiplier
    end
  end
end
