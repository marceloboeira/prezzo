module Uber
  module Calculators
    class PricePerDistance
      include Prezzo::Calculator

      def calculate
        price_per_kilometer * distance
      end

      def price_per_kilometer
        context.fetch(:price_per_kilometer)
      end

      def distance
        context.fetch(:distance)
      end
    end
  end
end
