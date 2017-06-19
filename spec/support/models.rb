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

class ComponentCalculator
  include Prezzo::Calculator

  component :foo, StaticCalculator

  def formula
    foo
  end
end

class ParamAndComponentCalculator
  include Prezzo::Calculator

  param :a_param
  component :foo, StaticCalculator
  component :bar, ParamCalculator

  def formula
    a_param + foo + bar
  end
end

class NestedCalculator
  include Prezzo::Calculator

  component :inner, ComponentCalculator

  def formula
    inner
  end
end

class UnusedParamCalculator
  include Prezzo::Calculator

  param :a_param

  def formula
    3
  end
end

class UnusedComponentCalculator
  include Prezzo::Calculator

  component :foo, StaticCalculator

  def formula
    3
  end
end

class NestedParamsCalculator
  include Prezzo::Calculator

  param :level1 do
    param :level2 do
      param :level3
    end
  end

  def formula
    level1.level2.level3
  end
end

class ComponentWithRestrictedContext
  include Prezzo::Calculator

  component :foo, ParamCalculator, :restricted

  def formula
    foo
  end
end

class DefaultParamCalculator
  include Prezzo::Calculator

  param :optional, default: 1.2

  def formula
    optional
  end
end
