require "simplecov"
SimpleCov.start

$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "prezzo"

RSpec::Expectations.configuration.on_potential_false_positives = :nothing
