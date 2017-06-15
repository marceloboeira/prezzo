require "spec_helper"

class DefinedCalculator
  include Prezzo::Calculator

  def calculate
    context.fetch(:distance) * 5
  end
end

class UndefinedCalculator
  include Prezzo::Calculator
end

RSpec.describe Prezzo::Calculator do
  describe "calculate" do
    context "when a class inherits from calculator" do
      context "and the calculate is not implemented" do
        let(:calculator) { UndefinedCalculator.new }

        it "raises an error" do
          expect { calculator.calculate }.to raise_error("Calculate not implemented")
        end
      end

      context "and the calculate is implemented" do
        let(:calculator) { DefinedCalculator.new(distance: 2) }

        it "returns the expected value" do
          expect(calculator.calculate).to eq(10)
        end
      end
    end
  end
end
