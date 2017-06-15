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

  component :foo, FooCalculator
  component :bar, BarCalculator

  def calculate
    foo + bar
  end
end

RSpec.describe Prezzo::Explainable do
  let(:subject) { ComposedCalculator.new }

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
