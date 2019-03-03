# frozen_string_literal: true

lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "box/office/version"

Gem::Specification.new do |spec|
  spec.name          = "box-office"
  spec.version       = Box::Office::VERSION
  spec.authors       = ["Drew Monroe"]
  spec.email         = ["dvmonroe6@gmail.com"]

  spec.summary       = "Reliable redis queueing"
  spec.homepage      = "http://github.com/dvmonroe/box-office"
  spec.license       = "MIT"

  spec.files         = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r(^exe/)) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "activesupport", "~> 5.2"
  spec.add_dependency "redis", "~> 4.1"
  spec.add_dependency "redlock", "~> 1.0"

  spec.add_development_dependency "bundler", "~> 1.17"
  spec.add_development_dependency "minitest", "~> 5.0"
  spec.add_development_dependency "minitest-reporters", ">= 1.3"
  spec.add_development_dependency "mocha"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rubocop", "~> 0.61.0"
end
