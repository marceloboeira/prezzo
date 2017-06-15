require "spec_helper"

class FooCalculator
  include Prezzo::Calculator

  def calculate
    10.0
  end
end

class BarCalculator
  include Prezzo::Calculator

  def calculate
    15.3
  end
end

class ComposedCalculator
  include Prezzo::Calculator

  param :some_param
  component :foo, FooCalculator
  component :bar, BarCalculator

  def calculate
    foo + bar
  end
end

RSpec.describe Prezzo::Composable do
  let(:context) { { some_param: 42.3 } }
  let(:calculator) { ComposedCalculator.new(context) }

  describe "components" do
    it "declares methods for the calculators" do
      expect(calculator.methods).to include(:foo, :bar)
    end

    it "initializes the calculators with the context" do
      expect(FooCalculator).to receive(:new).with(context).and_call_original

      calculator.foo
    end

    it "runs the calculators as methods" do
      expect(calculator.foo).to eq(10.0)
      expect(calculator.bar).to eq(15.3)
    end
  end

  describe "params" do
    it "declares methods for the params" do
      expect(calculator.methods).to include(:some_param)
    end

    it "reads the param from the context" do
      expect(calculator.some_param).to eq(42.3)
    end
  end

  describe "calculate" do
    it "returns the expected value" do
      expect(calculator.calculate).to eq(25.3)
    end
  end
end
