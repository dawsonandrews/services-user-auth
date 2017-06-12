# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "user_auth/version"

Gem::Specification.new do |spec|
  spec.name          = "da-user-auth"
  spec.version       = UserAuth::VERSION
  spec.authors       = ["Pete Hawkins"]
  spec.email         = ["pete@phawk.co.uk"]

  spec.summary       = %q{Rack compatible user authentication microservice}
  spec.description   = %q{Rack compatible user authentication microservice. Can be run standalone or mounted into another rack app.}
  spec.homepage      = "https://dawsonandrews.com/"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "da-core", "~> 0.1.5"
  spec.add_runtime_dependency "pg", "~> 0.20"
  spec.add_runtime_dependency "sequel", "~> 4.44.0"
  spec.add_runtime_dependency "bcrypt"

  spec.add_development_dependency "bundler", ">= 1.14"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "rack-test"
  spec.add_development_dependency "rubocop"
  spec.add_development_dependency "bundler-audit"
  spec.add_development_dependency "guard"
  spec.add_development_dependency "guard-rspec"
end
