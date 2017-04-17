require "spec_helper"

class DefaultCalculator
  include Prezzo::Calculator

  def calculate
    context.fetch(:distance, 0) * 5
  end
end

RSpec.describe Prezzo::Calculator do
  describe "context validation" do
    let(:default_context) { nil }
    let(:calculator) { DefaultCalculator.new(default_context) }

    context "when the context does not responds to valid?" do
      context "when there is no context" do
        it "raises an error" do
          expect { calculator }.to raise_error("Empty Context")
        end
      end

      context "and there is a context" do
        let(:default_context) { double(:context) }

        it "does not raises error" do
          expect { calculator }.to_not raise_error("Empty Context")
        end
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
      let(:calculator) { FooCalculator.new }

      context "and the calculate is not implemented" do
        before do
          class FooCalculator
            include Prezzo::Calculator
          end
        end

        it "raises an error" do
          expect { calculator.calculate }.to raise_error("Calculate not implemented")
        end
      end

      context "and the calculate is implemented" do
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
