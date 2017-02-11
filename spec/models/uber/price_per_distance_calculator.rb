module Uber
  class PricePerDistanceCalculator
    include Prezzo::Calculator

    def calculate
      price_per_kilometer * distance
    end

    def price_per_kilometer
      1.30
    end

    def distance
      context.fetch(:distance)
    end
  end
end
