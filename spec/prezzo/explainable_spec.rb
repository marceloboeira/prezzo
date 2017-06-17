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
      context "and they are used" do
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

      context "and they are not used" do
        let(:subject) { UnusedParamCalculator.new(context) }

        it "includes total and context" do
          expect(subject.explain).to eq(
            total: 3,
            context: {
              a_param: 10,
            },
          )
        end
      end
    end

    context "when there are components" do
      context "and they are used" do
        let(:subject) { ComponentCalculator.new(context) }

        it "includes total and components" do
          expect(subject.explain).to eq(
            total: 10.0,
            components: {
              foo: {
                total: 10.0,
              },
            },
          )
        end
      end

      context "and they are not used" do
        let(:subject) { UnusedComponentCalculator.new(context) }

        it "includes total and components" do
          expect(subject.explain).to eq(
            total: 3,
            components: {
              foo: {
                total: 10.0,
              },
            },
          )
        end
      end
    end

    context "when there are params and components" do
      let(:subject) { ParamAndComponentCalculator.new(context) }

      it "includes total, context and components" do
        expect(subject.explain).to eq(
          total: 35.3,
          context: {
            a_param: 10,
          },
          components: {
            foo: {
              total: 10.0,
            },
            bar: {
              total: 15.3,
              context: {
                bar_param: 15.3,
              },
            },
          },
        )
      end
    end

    context "nested calculators" do
      let(:subject) { NestedCalculator.new(context) }

      it "generates a nested explanation" do
        expect(subject.explain).to eq(
          total: 10.0,
          components: {
            inner: {
              total: 10.0,
              components: {
                foo: {
                  total: 10.0,
                },
              },
            },
          },
        )
      end
    end
  end
end
