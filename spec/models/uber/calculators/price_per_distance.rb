module Uber
  module Calculators
    class PricePerDistance
      include Prezzo::Calculator

      param :price_per_kilometer
      param :distance

      def calculate
        price_per_kilometer * distance
      end
    end
  end
end
