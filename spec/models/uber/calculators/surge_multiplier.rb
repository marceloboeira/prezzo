module Uber
  module Calculators
    class SurgeMultiplier
      include Prezzo::Calculator

      composed_by :total_cars,
                  :available_cars

      def formula
        1 + (1 - Math::log(available_cars, total_cars)).round(2)
      end
    end
  end
end
