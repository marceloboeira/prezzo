class FooCalculator
  include Prezzo::Calculator

  def formula
    10.0
  end
end

class BarCalculator
  include Prezzo::Calculator

  param :bar_param

  def formula
    bar_param
  end
end

class ComposedCalculator
  include Prezzo::Calculator

  param :a_param
  component :foo, FooCalculator
  component :bar, BarCalculator

  def formula
    foo + bar
  end
end

