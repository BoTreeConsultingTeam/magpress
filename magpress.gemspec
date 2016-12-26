# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'magpress/version'

Gem::Specification.new do |spec|
  spec.name          = "magpress"
  spec.version       = Magpress::VERSION
  spec.authors       = ["Amit Patel"]
  spec.email         = ["amit.patel@botreeconsulting.com"]

  spec.summary       = %q{Ruby wrapper of a custom WordPress plugin for http://www.magnificent.com}
  spec.homepage      = "https://github.com/BoTreeConsultingTeam/magpress"
  spec.description   = %q{Implements the complete functionality of the WordPress custom API for MAGnificent.}

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.9"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest"
  spec.add_development_dependency "minitest-spec-context", "~> 0.0.3"
  spec.add_development_dependency "mocha"
  spec.add_development_dependency "vcr"
  spec.add_development_dependency "webmock"
  spec.add_development_dependency "pry"

  spec.add_dependency "faraday"
  spec.add_dependency "faraday_middleware"
  spec.add_dependency "faraday-detailed_logger"
  spec.add_dependency "hashie"
  # spec.add_dependency "activesupport"
  spec.add_dependency "json"
end
