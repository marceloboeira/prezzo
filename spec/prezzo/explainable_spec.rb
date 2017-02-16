require "spec_helper"

describe Prezzo::Explainable do
  let(:foo_calculator_instance) { double(:calculator, calculate: 10.0) }
  let(:bar_calculator_instance) { double(:calculator, calculate: 15.3) }
  let(:foo_calculator_class) do
    double(:calculator, new: foo_calculator_instance)
  end
  let(:bar_calculator_class) do
    double(:calculator, new: bar_calculator_instance)
  end
  let(:calculation_context) { {} }
  let(:calculator) { ExplainedCalculator.new(calculation_context) }

  before do
    stub_const("FooCalculator", foo_calculator_class)
    stub_const("BarCalculator", bar_calculator_class)

    class ExplainedCalculator
      include Prezzo::Calculator
      include Prezzo::Composed
      include Prezzo::Explainable

      composed_by foo: FooCalculator,
                  bar: BarCalculator
      explain_with :foo, :bar

      def calculate
        foo + bar
      end
    end
  end

  describe "internals" do
    it "declares the explanation method" do
      expect(calculator.methods).to include(:explain)
    end
  end

  describe "explain" do
    it "returns the expected value" do
      expect(calculator.explain).to eq(foo: 10.0, bar: 15.3)
    end
  end
end
