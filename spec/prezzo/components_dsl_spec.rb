require "spec_helper"

RSpec.describe Prezzo::ComponentsDSL do
  let(:context) { Prezzo::Context.new(a_param: 5, bar_param: 15.3) }
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

    context "with a restricted context" do
      let(:context) { Prezzo::Context.new(bar_param: 1, restricted: { bar_param: 2 }) }
      let(:calculator) { ComponentWithRestrictedContext.new(context) }

      it "looks up values inside the restrited context" do
        expect(calculator.calculate).to eq(2)
      end
    end
  end
end
