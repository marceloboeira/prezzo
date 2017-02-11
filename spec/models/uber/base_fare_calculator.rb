module Uber
  class BaseFareCalculator
    include Prezzo::Calculator

    PRICE_PER_CATEGORY = {
      "UberX" => 4.0,
      "UberXL" => 6.0,
      "UberBLACK" => 8.0,
    }.freeze

    def calculate
      price_for(category) || 0
    end

    def category
      context.fetch(:category)
    end

    def price_for(category)
      PRICE_PER_CATEGORY[category]
    end
  end
end
