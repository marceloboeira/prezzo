require "spec_helper"

RSpec.describe Prezzo::Composable do
  let(:foo_calculator_instance) { double(:calculator, calculate: 10.0) }
  let(:bar_calculator_instance) { double(:calculator, calculate: 15.3) }
  let(:foo_calculator_class) do
    double(:calculator, new: foo_calculator_instance)
  end
  let(:bar_calculator_class) do
    double(:calculator, new: bar_calculator_instance)
  end
  let(:calculation_context) { { param_a: 1.3, param_b: 3.7 } }
  let(:calculator) { ComposedCalculator.new(calculation_context) }

  before do
    stub_const("FooCalculator", foo_calculator_class)
    stub_const("BarCalculator", bar_calculator_class)

    class ComposedCalculator
      include Prezzo::Calculator
      include Prezzo::Composable

      composed_by foo: FooCalculator,
                  bar: BarCalculator

      def calculate
        foo + bar
      end
    end

    class AnotherComposedCalculator
      include Prezzo::Calculator
      include Prezzo::Composable

      composed_by foo: FooCalculator,
                  far: BarCalculator

      def calculate
        boo + far
      end
    end
  end

  describe "internals" do
    it "declares methods for the calculators" do
      expect(calculator.methods).to include(:foo, :bar)
    end

    it "initializes the calculators with the context" do
      expect(FooCalculator).to receive(:new).with(calculation_context)
      expect(foo_calculator_instance).to receive(:calculate)

      calculator.foo
    end

    it "runs the calculators as methods" do
      expect(calculator.foo).to eq(10.0)
      expect(calculator.bar).to eq(15.3)
    end
  end

  describe "calculate" do
    it "returns the expected value" do
      expect(calculator.calculate).to eq(25.3)
    end
  end
end
