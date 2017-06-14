module Uber
  module Calculators
    class PricePerDistance
      include Prezzo::Calculator

      composed_by :price_per_kilometer,
                  :distance

      def formula
        price_per_kilometer * distance
      end
    end
  end
end
