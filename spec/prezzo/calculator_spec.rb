require "spec_helper"

class DefaultCalculator
  include Prezzo::Calculator

  composed_by :distance

  def calculate
    distance * 5
  end
end

class DefinedCalculator
  include Prezzo::Calculator

  def calculate
    10
  end
end

class UndefinedCalculator
  include Prezzo::Calculator
end

RSpec.describe Prezzo::Calculator do
  describe "context validation" do
    let(:default_context) { nil }
    let(:calculator) { DefaultCalculator.new(default_context) }

    context "when there is no context" do
      it "raises an error" do
        expect { calculator }.to raise_error("Empty Context")
      end
    end

    context "when the context does not respond to valid?" do
      let(:default_context) { double(:context) }

      it "does not raise error" do
        expect { calculator }.to_not raise_error("Empty Context")
      end
    end

    context "when the context responds to valid?" do
      context "when the context is invalid" do
        let(:default_context) { double(Prezzo::Context, valid?: false) }

        it "raises an error" do
          expect { calculator }.to raise_error("Invalid Context")
        end
      end

      context "when the context is valid" do
        let(:default_context) { double(Prezzo::Context, valid?: true) }

        it "raises an error" do
          expect { calculator }.to_not raise_error("Invalid Context")
        end

        it "validates the context" do
          expect(default_context).to receive(:valid?)

          calculator
        end
      end
    end
  end

  describe "calculate" do
    context "when a class inherits from calculator" do
      context "and calculate is not implemented" do
        let(:calculator) { UndefinedCalculator.new }

        it "raises an error" do
          expect { calculator.calculate }.to raise_error("Calculate not implemented")
        end
      end

      context "and calculate is implemented" do
        let(:calculator) { DefinedCalculator.new }

        it "returns the expected value" do
          expect(calculator.calculate).to eq(10)
        end
      end
    end
  end

  describe "composed_by" do
    let(:foo_calculator_instance) { double(:calculator, calculate: 10.0) }
    let(:bar_calculator_instance) { double(:calculator, calculate: 15.3) }
    let(:foo_calculator_class) do
      double(:calculator, new: foo_calculator_instance)
    end
    let(:bar_calculator_class) do
      double(:calculator, new: bar_calculator_instance)
    end
    let(:calculation_context) { { base_value: 3.7 } }
    let(:calculator) { ComposedCalculator.new(calculation_context) }

    before do
      stub_const("FooCalculator", foo_calculator_class)
      stub_const("BarCalculator", bar_calculator_class)

      class ComposedCalculator
        include Prezzo::Calculator

        composed_by :base_value,
                    foo: FooCalculator,
                    bar: BarCalculator

        def calculate
          base_value + foo + bar
        end
      end
    end

    it "declares methods for the calculators" do
      expect(calculator.methods).to include(:foo, :bar)
    end

    it "declares methods for the context values" do
      expect(calculator.methods).to include(:base_value)
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

    it "fetches the context value as a method" do
      expect(calculator.base_value).to eq(3.7)
    end
  end
end
