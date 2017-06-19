require "prezzo/version"

module Prezzo
  autoload :Calculator, "prezzo/calculator"
  autoload :ParamsDSL, "prezzo/params_dsl"
  autoload :ComponentsDSL, "prezzo/components_dsl"
  autoload :TransientDSL, "prezzo/transient_dsl"
  autoload :Context, "prezzo/context"
  autoload :Explainable, "prezzo/explainable"
end
