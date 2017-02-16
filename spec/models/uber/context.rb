module Uber
  class Context
    include Prezzo::Context
    CATEGORIES = ["UberX", "UberXL", "UberBlack"].freeze

    validations do
      required(:category).filled(included_in?: CATEGORIES)
      required(:distance).filled(:float?)
      required(:total_cars).filled(:int?)
      required(:available_cars).filled(:int?)
    end
  end
end
