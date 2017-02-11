require "spec_helper"
require "models/uber"

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
  let(:calculator) { Uber::RidePriceCalculator.new(ride_context) }
  let(:price) { calculator.calculate }

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
