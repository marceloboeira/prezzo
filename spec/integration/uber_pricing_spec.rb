require "spec_helper"
require "models/uber"

RSpec.describe "Uber Pricing" do
  let(:distance) { 10.0 }
  let(:available_cars) { 30 }
  let(:category) { "UberX" }
  let(:ride_context) do
    Prezzo::Context.new(category: category,
                        distance: distance,
                        total_cars: 100,
                        price_per_kilometer: 1.3,
                        available_cars: available_cars)
  end
  let(:calculator) { Uber::RidePrice.new(ride_context) }
  let(:price) { calculator.calculate }

  context "when the context is valid" do
    describe "calculate" do
      context "when the category is UberX" do
        context "and there is no distance" do
          let(:distance) { 0.0 }

          context "and all the cars are available" do
            let(:available_cars) { 100 }

            it "returns the base fare for the UberX" do
              expect(price).to eq(4.0)
            end
          end
        end

        context "and there is distance" do
          let(:distance) { 13.0 }

          context "and all the cars are available" do
            let(:available_cars) { 100 }

            it "adds the price per kilometer" do
              expect(price.round(2)).to eq(20.9)
            end
          end

          context "and not all the cares are available" do
            context "and all the cars are available" do
              let(:available_cars) { 40 }

              it "adds the additional per demand" do
                expect(price.round(2)).to eq(25.08)
              end
            end
          end
        end
      end
    end

    describe "explain" do
      it "returns a hash with all the explainable params" do
        expect(calculator.explain).to eq(
          total: 21.42,
          components: {
            base_fare: {
              total: 4.0,
              context: {
                category: "UberX",
              },
            },
            price_per_distance: {
              total: 13.0,
              context: {
                price_per_kilometer: 1.3,
                distance: 10.0,
              },
            },
            surge_multiplier: {
              total: 1.26,
              context: {
                total_cars: 100,
                available_cars: 30,
              },
            },
          },
        )
      end
    end
  end

  context "when the contex is invalid" do
    let(:ride_context) do
      Uber::Context.new(category: "foo")
    end

    it "raises an invalid context error" do
      expect { calculator }.to raise_error
    end
  end
end
