require "spec_helper"

RSpec.describe Prezzo::Explainable do
  let(:context) { { a_param: 10, bar_param: 15.3 } }

  describe "internals" do
    let(:subject) { ParamAndComponentCalculator.new(context) }

    it "declares the explanation method" do
      expect(subject.methods).to include(:explain)
    end
  end

  describe "explain" do
    context "when there are no params and components" do
      let(:subject) { StaticCalculator.new(context) }

      it "includes only total" do
        expect(subject.explain).to eq(
          total: 10.0,
        )
      end
    end

    context "when there are params" do
      let(:subject) { ParamCalculator.new(context) }

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
      let(:subject) { ComponentCalculator.new(context) }

      it "includes total and components" do
        expect(subject.explain).to eq(
          total: 10.0,
          components: {
            foo: 10.0,
          },
        )
      end
    end
  end
end
