# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'active_stripper/version'

Gem::Specification.new do |spec|
  spec.required_ruby_version = '~> 2.0'

  spec.name          = "active_stripper"
  spec.version       = ActiveStripper::VERSION
  spec.authors       = ["François TCHENG"]
  spec.email         = ["tcheng.f@gmail.com"]

  spec.summary       = %q{Strip or preprocess Active Record / Object attributes with prepended setter}
  spec.description   = %q{
    Strip or preprocess Active Record / Object attributes by creating custom setter through module prepending.
    Work with any Object in ruby and still allow custom setter to be defined inside the class.
    For exemple, can lowercase an email field during attribute setting for ActiveRecord instances
    instead of having to hook on validation hook on ActiveRecord.}
  spec.homepage      = "https://github.com/nekogami/active_stripper"
  spec.license       = "MIT"

  spec.files         = Dir["./lib/**/*.rb"]

  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
