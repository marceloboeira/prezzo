require "spec_helper"

class DefaultCalculator
  include Prezzo::Calculator

  def formula
    context.fetch(:distance, 0) * 5
  end
end

class DefinedCalculator
  include Prezzo::Calculator

  def formula
    10
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
          expect { calculator.calculate }.to raise_error("Formula not implemented")
        end
      end

      context "and the calculate is implemented" do
        let(:calculator) { DefinedCalculator.new }

        context "when there are not context options" do
          it "returns the expected value" do
            expect(calculator.calculate).to eq(10)
          end
        end
      end
    end

    context "without a context" do
      let(:calculator) { StaticCalculator.new }

      it "works for static calculators" do
        expect(calculator.calculate).to eq(10.0)
      end
    end
  end
end
