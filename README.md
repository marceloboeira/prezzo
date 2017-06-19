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

### The calculation context

`Prezzo::Context` is a source of data for your calculators. It receives a hash
of params and makes them available to calculators.

e.g.:

```ruby
context = Prezzo::Context.new(category: "Expensive", distance: 10.0)
```

### Simple calculators

`Prezzo::Calculator` is the top level concept to describe calculations. Define
a `formula` method that describe the calculation you want to perform and call
the `calculate` method.

e.g.:

```ruby
require "prezzo"

class StaticCalculator
  include Prezzo::Calculator

  def formula
    2 * 5
  end
end

StaticCalculator.new.calculate
#=> 10
```

### Accessing context params

Use the `param` dsl to create methods that read data from the context.

e.g.:

```ruby
require "prezzo"

class Multiplier
  include Prezzo::Calculator

  param :arg1
  param :arg2

  def formula
    arg1 * arg2
  end
end

context = Prezzo::Context.new(arg1: 2, arg2: 10.0)
Multiplier.new(context).calculate
#=> 20.0
```

### Nested context params

The `param` dsl can take a block to access nested data in the context.

e.g.:

```ruby
require "prezzo"

class NestedCalculator
  include Prezzo::Calculator

  param :level1 do
    param :level2
  end

  def formula
    level1.level2 * 2
  end
end

context = Prezzo::Context.new(level1: { level2: 10.0 })
NestedCalculator.new(context).calculate
#=> 20.0
```

### Composing calculators

Calculators provide the `component` dsl method to make it easy to compose
calculators. Each calculator will be defined as a method in the calculator.
They will receive the whole context on instantiation.

e.g.:

```ruby
require "prezzo"

class ComposedCalculator
  include Prezzo::Calculator

  component :calculator1, StaticCalculator
  component :calculator2, Multiplier

  def formula
    calculator1 + calculator2
  end
end

context = Prezzo::Context.new(arg1: 2, arg2: 10.0)
ComposedCalculator.new(context).calculate
#=> 30.0
```

### Explanations

The `explain` method provides a nice way of representing how the price was
composed. It will include all params and components defined in the calculator.

e.g.:

```ruby
require "prezzo"

class ExplainableCalculator
  include Prezzo::Calculator

  param :value
  component :calculator1, StaticCalculator
  component :calculator2, Multiplier

  def formula
    value + calculator1 + calculator2
  end
end

context = Prezzo::Context.new(value: 3, arg1: 2, arg2: 10.0)
ExplainableCalculator.new(context).explain
#=> { total: 33.0, context: { value: 3 }, components: { calculator1: { ... }, calculator2: { ... } } }
```

Check the full [Uber pricing](/spec/integration/uber_pricing_spec.rb) for more complete example with many calculators and factors.

## Development

After checking out the repo, run `make` to install dependencies. Then, run `make spec` to run the tests. You can also run `make console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `make install`. To release a new version, update the version number in `version.rb`, and then run `make release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Please consider reading out [Contributing Guide](CONTRIBUTING.md).

This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.
