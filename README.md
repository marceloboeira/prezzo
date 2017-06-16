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


`Prezzo::Context` is a source of data for your calculators. It receives a hash
of params and validates its content in order to make the calculations safe.

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

`Prezzo::Calculator` is a simple interface for injecting dependencies on
your calculators and calculating the price. It makes it possible to
receive a Context of parameters containing the necessary information
to calculate your price and perform the calculations.

Use the `param` dsl to create methods that read data from the context.

e.g.:

```ruby
require "prezzo"

module Uber
  class PricePerDistanceCalculator
    include Prezzo::Calculator

    param :price_per_kilometer
    param :distance

    def formula
      price_per_kilometer * distance
    end
  end
end

context = Uber::Context.new(distance: 10.0, price_per_kilometer: 2)
Uber::PricePerDistanceCalculator.new(context).calculate
#=> 20.0
```

**Context Validation**

If you initialize the calculator with a hash, it will skip the validation.
However, any object that responds to `.valid?` will attempt a validation, and
it will fail if valid? returns false.

### Composing calculators

Calculators provide the `component` dsl method to make it easy to compose
calculators. Each component will be defined as a method in the calculator.

e.g.:

```ruby
require "prezzo"

module Uber
  class RidePriceCalculator
    include Prezzo::Calculator

    component :base_fare, BaseFareCalculator
    component :price_per_distance, PricePerDistanceCalculator

    def formula
      base_fare + price_per_distance
    end
  end
end

context = Uber::Context.new(distance: 10.0)
Uber::RidePriceCalculator.new(context).calculate
#=> 47.3
```

### Explanations

The `explain` method provides a nice way of representing how the price was
composed. Only params and components that are actually used on the calculation
are included in the explanation.

e.g.:

```ruby
require "prezzo"

module Uber
  class RidePriceCalculator
    include Prezzo::Calculator

    param :value
    component :base_fare, BaseFareCalculator
    component :price_per_distance, PricePerDistanceCalculator

    def formula
      value + base_fare + price_per_distance
    end
  end
end

context = Uber::Context.new(distance: 10.0, value: 3, ...)
Uber::RidePriceCalculator.new(context).explain
#=> { total: 28, context: { value: 3 }, components: { base_fare: 4.3, price_per_distance: 21.3 } }
```

Check the full [Uber pricing](/spec/integration/uber_pricing_spec.rb) for more complete example with many calculators and factors.

## Development

After checking out the repo, run `make` to install dependencies. Then, run `make spec` to run the tests. You can also run `make console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `make install`. To release a new version, update the version number in `version.rb`, and then run `make release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Please consider reading out [Contributing Guide](CONTRIBUTING.md).

This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.
