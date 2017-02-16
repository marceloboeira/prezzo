require "spec_helper"

class FooContext
  include Prezzo::Context
  CATEGORIES = ["Foo", "Bar"].freeze

  validations do
    required(:category).filled(included_in?: CATEGORIES)
    required(:distance).maybe(:float?)
  end
end

describe Prezzo::Context do
  describe "validations" do
    context "when the data is valid" do
      let(:valid_context) do
        FooContext.new(category: "Foo", distance: 10.0)
      end

      it "returns true" do
        expect(valid_context).to be_valid
      end
    end

    context "when the data is invalid" do
      let(:invalid_context) do
        FooContext.new(distance: 10)
      end

      it "returns false" do
        expect(invalid_context).to_not be_valid
      end

      describe "errors" do
        it "has the reasons of failure" do
          expect(invalid_context.errors).to include(category: ["is missing"])
          expect(invalid_context.errors).to include(distance: ["must be a float"])
        end
      end
    end
  end

  describe "attributes" do
    let(:valid_context) do
      FooContext.new(category: "Foo", distance: 10.0)
    end

    it "ouputs the attributes as hash" do
      expect(valid_context.attributes).to include(:category, :distance)
    end

    describe "fetch" do
      context "when the attribute is valid" do
        it "returns the attributes' value" do
          expect(valid_context.fetch(:category)).to eq("Foo")
        end
      end

      context "when the attribute is not valid" do
        it "raises an error" do
          expect { valid_context.fetch(:invalid) }.to raise_error(KeyError)
        end
      end
    end
  end
end
