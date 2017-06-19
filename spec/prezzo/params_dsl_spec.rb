require "spec_helper"

RSpec.describe Prezzo::ParamsDSL do
  let(:context) { Prezzo::Context.new(a_param: 5, bar_param: 15.3) }
  let(:calculator) { ParamAndComponentCalculator.new(context) }

  describe "params" do
    it "declares methods for the params" do
      expect(calculator.methods).to include(:a_param)
    end

    it "reads the param from the context" do
      expect(calculator.a_param).to eq(5)
    end
  end

  describe "nested params" do
    let(:context) { Prezzo::Context.new(level1: { level2: { level3: 3 } }) }
    let(:calculator) { NestedParamsCalculator.new(context) }

    it "fetches the correct nested value from the context" do
      expect(calculator.calculate).to eq(3)
    end
  end
end
