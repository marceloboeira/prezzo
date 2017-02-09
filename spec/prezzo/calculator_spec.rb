require "spec_helper"

describe Prezzo::Calculator do
  describe "calculate" do
    context "when a class inherits from calculator" do
      let(:calculator) { FooCalculator.new }

      context "and the calculate is not implemented" do
        before do
          class FooCalculator
            include Prezzo::Calculator
          end
        end

        it "returns zero" do
          expect(calculator.calculate).to eq(0)
        end
      end

      context "and the calculate is implemented" do
        context "when there are context options" do
          context "and the options are provided" do
            before do
              class FooCalculator
                include Prezzo::Calculator

                def calculate
                  5 * context.fetch(:bar)
                end
              end
            end

            let(:calculator) { FooCalculator.new(bar: 10) }

            it "returns the expected value" do
              expect(calculator.calculate).to eq(50)
            end
          end

          context "and the options are not provided properly" do
            before do
              class FooCalculator
                include Prezzo::Calculator

                def calculate
                  5 * context.fetch(:bar)
                end
              end
            end

            let(:calculator) { FooCalculator.new(nope: 10) }

            it "raises a KeyError" do
              expect { calculator.calculate }.to raise_error(KeyError)
            end
          end
        end

        context "when there are not context options" do
          before do
            class FooCalculator
              include Prezzo::Calculator

              def calculate
                10
              end
            end
          end

          it "returns the expected value" do
            expect(calculator.calculate).to eq(10)
          end
        end
      end
    end
  end
end
