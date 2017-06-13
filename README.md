# Prezzo [![Build Status](https://travis-ci.org/marceloboeira/prezzo.svg?branch=master)](https://travis-ci.org/marceloboeira/prezzo) [![Code Climate](https://codeclimate.com/github/marceloboeira/prezzo.png)](https://codeclimate.com/github/marceloboeira/prezzo)
> Toolbox to create complex pricing models

## Installation

Add this line to your application's Gemfile:

```ruby
gem "prezzo"
```

And then execute:

```
$ bundle
```

Or install it yourself as:

```
$ gem install prezzo
```

## Usage

### Prezzo::Context


`Prezzo::Context` is a source of data for your calculators. It receives a
hash of params and validates its content, in order to make the calculations
safe.

e.g.:

```ruby
module Uber
  class Context
    include Prezzo::Context
    CATEGORIES = ["UberX", "UberXL", "UberBlack"].freeze

    validations do
      required(:category).filled(included_in?: CATEGORIES)
      required(:distance).filled(:float?)
      required(:total_cars).filled(:int?)
      required(:available_cars).filled(:int?)
      required(:price_per_kilometer).filled(:float?)
    end
  end
end

context = Uber::Context.new(category: "UberBlack", ...)

# when valid
context.valid?
#=> true

# when invalid
context.valid?
#=> false

context.errors
# { distance: ["must be a float"]}
```

### Prezzo::Calculator

`Prezzo::Calculator` is how you take input values and compute the price. The
`composed_by` dsl defines methods that read values from the context.

e.g.:

```ruby
require "prezzo"

module Uber
  class PricePerDistanceCalculator
    include Prezzo::Calculator

    composed_by :distance,
                :price_per_kilometer

    def calculate
      price_per_kilometer * distance
    end
  end
end

context = Uber::Context.new(distance: 10.0, price_per_kilometer: 1.3, ...)
Uber::PricePerDistanceCalculator.new(context).calculate
#=> 13.0
```

**Validation**

If you initialize the calculator with a hash, it will skip the validation,
however, any object that responds to `.valid?` will attempt a validation, and
it will fail if valid? returns false.

### Composing calculators

The last argument to `composed_by` can be a Hash of calculators. These
calculators will be available as methods.

e.g.:

```ruby
require "prezzo"

module Uber
  class RidePriceCalculator
    include Prezzo::Calculator
    include Prezzo::Composable

    composed_by base_fare: BaseFareCalculator,
                price_per_distance: PricePerDistanceCalculator,

    def calculate
      base_fare + price_per_distance
    end
  end
end

context = Uber::Context.new(distance: 10.0, ...)
Uber::RidePriceCalculator.new(context).calculate
#=> 47.3
```

### Prezzo::Explainable

The `Prezzo::Explainable` module is an abstraction that provides a nice way of representing how the price was composed.

e.g.:

```ruby
require "prezzo"

module Uber
  class RidePriceCalculator
    include Prezzo::Calculator
    include Prezzo::Composable
    include Prezzo::Explainable

    composed_by base_fare: BaseFareCalculator,
                price_per_distance: PricePerDistanceCalculator,
    explain_with :base_fare, :price_per_distance

    def calculate
      base_fare + price_per_distance
    end
  end
end

context = Uber::Context.new(distance: 10.0)
Uber::RidePriceCalculator.new(context).explain
#=> { base_fare: 4.3, price_per_distance: 21.3 }
```

Check the full [Uber pricing](/spec/integration/uber_pricing_spec.rb) for more complete example with many calculators and factors.

## Development

After checking out the repo, run `make` to install dependencies. Then, run `make spec` to run the tests. You can also run `make console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `make install`. To release a new version, update the version number in `version.rb`, and then run `make release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Please consider reading out [Contributing Guide](CONTRIBUTING.md).

This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.
