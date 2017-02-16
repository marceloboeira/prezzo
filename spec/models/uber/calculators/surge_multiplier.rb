module Uber
  module Calculators
    class SurgeMultiplier
      include Prezzo::Calculator

      def calculate
        total_cars = context.fetch(:total_cars)
        available_cars = context.fetch(:available_cars)

        1 + (1 - Math::log(available_cars, total_cars)).round(2)
      end
    end
  end
end
