module Uber
  class AdditionalPerDemandCalculator
    include Prezzo::Calculator

    def calculate
      total_cars = context.fetch(:total_cars)
      available_cars = context.fetch(:available_cars)

      50 * (1 - Math::log(available_cars, total_cars))
    end
  end
end
