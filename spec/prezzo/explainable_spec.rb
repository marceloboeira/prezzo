require "spec_helper"

class FooCalculator
  include Prezzo::Calculator

  def formula
    10.0
  end
end

class BarCalculator
  include Prezzo::Calculator

  param :bar_param

  def formula
    bar_param
  end
end

class ComposedCalculator
  include Prezzo::Calculator

  param :a_param
  component :foo, FooCalculator
  component :bar, BarCalculator

  def formula
    foo + bar
  end
end

RSpec.describe Prezzo::Explainable do
  let(:context) { { a_param: 10, bar_param: 15.3 } }
  let(:subject) { ComposedCalculator.new(context) }

  describe "internals" do
    it "declares the explanation method" do
      expect(subject.methods).to include(:explain)
    end
  end

  describe "explain" do
    context "when there are no params and components" do
      let(:subject) { FooCalculator.new(context) }

      it "includes only total" do
        expect(subject.explain).to eq(
          total: 10.0,
        )
      end
    end

    context "when there are params" do
      let(:subject) { BarCalculator.new(context) }

      it "includes total and context" do
        expect(subject.explain).to eq(
          total: 15.3,
          context: {
            bar_param: 15.3,
          },
        )
      end
    end

    context "when there are components" do
      it "includes total and components" do
        expect(subject.explain).to eq(
          total: 25.3,
          components: {
            foo: 10.0,
            bar: 15.3,
          },
        )
      end
    end
  end
end
