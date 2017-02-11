# Prezzo [![Build Status](https://travis-ci.org/marceloboeira/prezzo.svg?branch=master)](https://travis-ci.org/marceloboeira/prezzo)
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

### Prezzo::Calculator

The `Prezzo::Calculator` is a simple interface for injecting dependencies on your calculators and calculating the price. Basically, it makes it possible to receive the context, an Hash of parameters containing the necessary information to calculate your price.

e.g.:

```ruby
require "prezzo"

module Uber
  class PricePerDistanceCalculator
    include Prezzo::Calculator

    def calculate
      price_per_kilometer * distance
    end

    def price_per_kilometer
      1.30
    end

    def distance
      context.fetch(:distance)
    end
  end
end

Uber::PricePerDistanceCalculator.new(distance: 10.0).calculate
#=> 20.0
```

### Prezzo::Composed

The `Prezzo::Composed` module is an abstraction that provides a nice way of injecting other calculators define how the price will be composed with all of those calculators.

e.g.:

```ruby
require "prezzo"

module Uber
  class RidePriceCalculator
    include Prezzo::Calculator
    include Prezzo::Composed

    composed_by base_fare: BaseFareCalculator,
                price_per_distance: PricePerDistanceCalculator,
                additional_per_demand: AdditionalPerDemandCalculator

    def calculate
      base_fare + price_per_distance + additional_per_demand
    end
  end
end

Uber::RidePriceCalculator.new(distance: 10.0, category: "UberBlack", ...).calculate
#=> 47.3
```

Check the full [Uber pricing](/spec/integration/uber_pricing_spec.rb) for more complete example with many calculators and factors.

## Development

After checking out the repo, run `make` to install dependencies. Then, run `make spec` to run the tests. You can also run `make console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `make install`. To release a new version, update the version number in `version.rb`, and then run `make release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Please consider reading out [Contributing Guide](CONTRIBUTING.md).

This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.
