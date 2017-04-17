require "spec_helper"

RSpec.describe Prezzo::Explainable do
  let(:foo_calculator_instance) { double(:calculator, calculate: 10.0) }
  let(:bar_calculator_instance) { double(:calculator, calculate: 15.3) }
  let(:foo_calculator_class) do
    double(:calculator, new: foo_calculator_instance)
  end
  let(:bar_calculator_class) do
    double(:calculator, new: bar_calculator_instance)
  end
  let(:calculation_context) { {} }

  before do
    stub_const("FooCalculator", foo_calculator_class)
    stub_const("BarCalculator", bar_calculator_class)

    class ExplainedCalculator
      include Prezzo::Calculator
      include Prezzo::Composable
      include Prezzo::Explainable

      composed_by foo: FooCalculator,
                  bar: BarCalculator
      explain_with :foo, :bar

      def calculate
        foo + bar
      end
    end

    class ExplainedClass
      include Prezzo::Explainable
      explain_with :boo, :far

      def boo
        10.0
      end

      def far
        20.0
      end
    end
  end

  context "when the class is only explainable" do
    let(:subject) { ExplainedClass.new }

    describe "internals" do
      it "declares the explanation method" do
        expect(subject.methods).to include(:explain)
      end
    end

    describe "explain" do
      it "returns the expected value" do
        expect(subject.explain).to eq(boo: 10.0, far: 20.0)
      end
    end
  end

  context "when the class is also a calculator" do
    let(:subject) { ExplainedCalculator.new(calculation_context) }

    describe "internals" do
      it "declares the explanation method" do
        expect(subject.methods).to include(:explain)
      end
    end

    describe "explain" do
      it "returns the expected value" do
        expect(subject.explain).to eq(foo: 10.0, bar: 15.3)
      end
    end
  end
end
