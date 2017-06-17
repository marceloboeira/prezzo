class StaticCalculator
  include Prezzo::Calculator

  def formula
    10.0
  end
end

class ParamCalculator
  include Prezzo::Calculator

  param :bar_param

  def formula
    bar_param
  end
end

class ParamAndComponentCalculator
  include Prezzo::Calculator

  param :a_param
  component :foo, StaticCalculator
  component :bar, ParamCalculator

  def formula
    foo + bar
  end
end

