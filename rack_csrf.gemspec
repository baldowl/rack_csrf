# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rack/csrf/version'

Gem::Specification.new do |spec|
  spec.name                  = 'rack_csrf'
  spec.version               = Rack::Csrf::VERSION
  spec.authors               = ['Emanuele Vicentini']
  spec.email                 = ['emanuele.vicentini@gmail.com']
  spec.description           = 'Anti-CSRF Rack middleware'
  spec.summary               = 'Anti-CSRF Rack middleware'
  spec.homepage              = 'https://github.com/baldowl/rack_csrf'
  spec.license               = 'MIT'

  spec.files                 = `git ls-files -z`.split("\x0")
  spec.test_files            = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths         = ['lib']

  spec.rdoc_options          = [
    '--line-numbers',
    '--inline-source',
    '--title',
    "Rack::Csrf #{Rack::Csrf::VERSION}",
    '--main',
    'README.rdoc'
  ]
  spec.extra_rdoc_files      = [
    'LICENSE.rdoc',
    'README.rdoc'
  ]

  spec.required_ruby_version = '>= 1.9.2'

  if ENV['TEST_WITH_RACK']
    spec.add_runtime_dependency 'rack', "~> #{ENV['TEST_WITH_RACK']}"
  else
    spec.add_runtime_dependency 'rack', '>= 1.1.0'
  end

  spec.add_development_dependency 'bundler', '>= 1.0.0'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'cucumber', '~> 3.0'
  spec.add_development_dependency 'rack-test', '>= 0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rdoc', '>= 2.4.2'
  spec.add_development_dependency 'git', '>= 1.2.5'
end
