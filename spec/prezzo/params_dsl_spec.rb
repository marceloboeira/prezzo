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

  describe "optional param" do
    let(:calculator) { DefaultParamCalculator.new(context) }

    context "when param is defined" do
      let(:context) { Prezzo::Context.new(optional: 3) }

      it "reads the param" do
        expect(calculator.calculate).to eq(3)
      end
    end

    context "when param is not defined" do
      let(:context) { Prezzo::Context.new(other: 4) }

      it "reads the default" do
        expect(calculator.calculate).to eq(1.2)
      end
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
