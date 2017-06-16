module Uber
  module Calculators
    class BaseFare
      include Prezzo::Calculator

      param :category

      PRICE_PER_CATEGORY = {
        "UberX" => 4.0,
        "UberXL" => 6.0,
        "UberBLACK" => 8.0,
      }.freeze

      def formula
        PRICE_PER_CATEGORY.fetch(category, 0)
      end
    end
  end
end
