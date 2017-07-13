require "spec_helper"

RSpec.describe Prezzo::Explainable do
  before do
    class FooCalculator
      include Prezzo::Calculator

      def calculate
        10.0
      end
    end

    class BarCalculator
      include Prezzo::Calculator
      include Prezzo::Composable
      include Prezzo::Explainable

      composed_by foo: FooCalculator

      explain_with :foo

      def calculate
        foo + 5.3
      end
    end

    class ExplainedCalculator
      include Prezzo::Calculator
      include Prezzo::Composable
      include Prezzo::Explainable

      composed_by foo: FooCalculator,
                  bar: BarCalculator

      explain_with :foo, :bar
      explain_with :other

      def calculate
        foo + bar
      end

      private

      def other
        5
      end
    end
  end

  let(:subject) { ExplainedCalculator.new }

  describe "internals" do
    it "declares the explanation method" do
      expect(subject.methods).to include(:explain)
    end
  end

  describe "explain" do
    context "when resursive is not given" do
      before do
        class ExplainedCalculator
          explain_with :foo, :bar
          explain_with :other
        end
      end

      it "returns the expected value" do
        expect(subject.explain).to eq(
          total: 25.3,
          components: {
            foo: 10.0,
            bar: {
              total: 15.3,
              components: {
                foo: 10.0,
              },
            },
            other: 5,
          },
        )
      end
    end

    context "when resursive = false is given" do
      before do
        class ExplainedCalculator
          explain_with :foo, :bar, :other, resursive: false
        end
      end

      it "returns the expected value" do
        expect(subject.explain).to eq(
          total: 25.3,
          components: {
            foo: 10.0,
            bar: 15.3,
            other: 5,
          },
        )
      end
    end
  end
end
