require "spec_helper"

module Uber
  class BaseFareCalculator
    include Prezzo::Calculator

    def calculate
      price_for(category) || 0
    end

    def category
      context.fetch(:category)
    end

    def price_for(category)
      { "UberX" => 4.0,
        "UberXL" => 6.0,
        "UberBLACK" => 8.0 }[category]
    end
  end

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

  class AdditionalPerDemandCalculator
    include Prezzo::Calculator

    def calculate
      total_cars = context.fetch(:total_cars)
      available_cars = context.fetch(:available_cars)

      50 * (1 - Math::log(available_cars, total_cars))
    end
  end
end

RSpec.describe "Uber Pricing" do
  let(:distance) { 10.0 }
  let(:available_cars) { 30 }
  let(:category) { "UberX" }
  let(:ride_context) do
    {
      category: category,
      distance: distance,
      total_cars: 100,
      available_cars: available_cars,
    }
  end
  let(:calculators) do
    [ Uber::BaseFareCalculator.new(ride_context),
      Uber::PricePerDistanceCalculator.new(ride_context),
      Uber::AdditionalPerDemandCalculator.new(ride_context) ]
  end
  let(:price) do
    calculators.map(&:calculate).reduce(:+)
  end

  context "when the category is UberX" do
    context "and there is no distance" do
      let(:distance) { 0.0 }

      context "and all the cars are available" do
        let(:available_cars) { 100 }

        it "returns the base fare for the UberX" do
          expect(price).to be(4.0)
        end
      end
    end

    context "and there is distance" do
      let(:distance) { 13.0 }

      context "and all the cars are available" do
        let(:available_cars) { 100 }

        it "adds the price per kilometer" do
          expect(price.round(2)).to be(20.9)
        end
      end

      context "and not all the cares are available" do
        context "and all the cars are available" do
          let(:available_cars) { 40 }

          it "adds the additional per demand" do
            expect(price.round(2)).to be(30.85)
          end
        end
      end
    end
  end
end
