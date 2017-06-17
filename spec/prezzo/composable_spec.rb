require "spec_helper"

RSpec.describe Prezzo::Composable do
  let(:context) { { a_param: 5, bar_param: 15.3 } }
  let(:calculator) { ParamAndComponentCalculator.new(context) }

  describe "components" do
    it "declares methods for the calculators" do
      expect(calculator.methods).to include(:foo, :bar)
    end

    it "initializes the calculators with the context" do
      expect(StaticCalculator).to receive(:new).with(context).and_call_original

      calculator.foo
    end

    it "runs the calculators as methods" do
      expect(calculator.foo).to eq(10.0)
      expect(calculator.bar).to eq(15.3)
    end
  end

  describe "params" do
    it "declares methods for the params" do
      expect(calculator.methods).to include(:a_param)
    end

    it "reads the param from the context" do
      expect(calculator.a_param).to eq(5)
    end
  end

  describe "calculate" do
    it "returns the expected value" do
      expect(calculator.calculate).to eq(30.3)
    end
  end
end
