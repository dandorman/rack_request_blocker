# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rack_request_blocker/version'

Gem::Specification.new do |spec|
  spec.name          = "rack_request_blocker"
  spec.version       = RackRequestBlocker::VERSION
  spec.authors       = ["Dan Dorman"]
  spec.email         = ["dan.dorman@gmail.com"]
  spec.summary       = %q{Inserts a request-blocking Rack middleware for full-stack testing.}
  spec.description   = %q{Inserts a middleware at the top of the stack that stops further requests and waits for in-flight requests to complete before proceeding. This is helpful for Capybara full-stack tests where AJAX requests still in-flight interfere with test tear-down. Based on "Tearing Down Capybara Tests of AJAX Pages" by Joel Turkel at Salsify. <http://blog.salsify.com/engineering/tearing-capybara-ajax-tests>}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "atomic", "~> 1.1.16"

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.1.0"
end
