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

      def calculate
        15.3
      end
    end

    class ExplainedCalculator
      include Prezzo::Calculator
      include Prezzo::Composable
      include Prezzo::Explainable

      composed_by foo: FooCalculator,
                  bar: BarCalculator

      explain_with :foo, :bar, :other

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
