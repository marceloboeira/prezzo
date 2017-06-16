module Uber
  module Calculators
    class SurgeMultiplier
      include Prezzo::Calculator

      param :total_cars
      param :available_cars

      def formula
        1 + (1 - Math::log(available_cars, total_cars)).round(2)
      end
    end
  end
end
