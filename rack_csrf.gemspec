# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rack/csrf/version'

Gem::Specification.new do |s|
  s.name = "rack_csrf"
  s.version = Rack::Csrf::VERSION

  s.authors = ["Emanuele Vicentini"]
  s.description = "Anti-CSRF Rack middleware"
  s.email = "emanuele.vicentini@gmail.com"
  s.extra_rdoc_files = [
    "LICENSE.rdoc",
    "README.rdoc"
  ]
  s.files = `git ls-files`.split($/)
  s.homepage = "https://github.com/baldowl/rack_csrf"
  s.licenses = ["MIT"]
  s.rdoc_options = ["--line-numbers", "--inline-source", "--title", "Rack::Csrf #{Rack::Csrf::VERSION}", "--main", "README.rdoc"]
  s.require_paths = ["lib"]
  s.required_ruby_version = Gem::Requirement.new(">= 1.8.7")
  s.summary = "Anti-CSRF Rack middleware"

  s.add_runtime_dependency 'rack', ">= 0.9"

  s.add_development_dependency 'bundler', ">= 1.0.0"
  s.add_development_dependency 'rake'
  s.add_development_dependency 'cucumber', ">= 1.1.1"
  s.add_development_dependency 'rack-test', ">= 0"
  s.add_development_dependency 'rspec', ">= 2.0.0"
  s.add_development_dependency 'rdoc', ">= 2.4.2"
  s.add_development_dependency 'git', '>= 1.2.5'
end
