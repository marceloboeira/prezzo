require "spec_helper"

RSpec.describe Prezzo::TransientDSL do
  let(:context) { Prezzo::Context.new(value: 1) }
  let(:calculator) { TransientCalculator.new(context) }

  describe "transient" do
    it "declares methods for the transients" do
      expect(calculator.methods).to include(:intermediate_value)
    end

    it "returns the correct value" do
      expect(calculator.intermediate_value).to eq(5)
    end
  end
end
