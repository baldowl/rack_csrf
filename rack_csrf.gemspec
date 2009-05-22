--- !ruby/object:Gem::Specification 
name: rack_csrf
version: !ruby/object:Gem::Version 
  version: 1.1.0
platform: ruby
authors: 
- Emanuele Vicentini
autorequire: 
bindir: bin

date: 2009-05-22 00:00:00 +02:00
default_executable: 
dependencies: 
- !ruby/object:Gem::Dependency 
  name: rack
  type: :runtime
  version_requirement: 
  version_requirements: !ruby/object:Gem::Requirement 
    requirements: 
    - - ">="
      - !ruby/object:Gem::Version 
        version: "0.9"
    version: 
- !ruby/object:Gem::Dependency 
  name: rake
  type: :development
  version_requirement: 
  version_requirements: !ruby/object:Gem::Requirement 
    requirements: 
    - - ">="
      - !ruby/object:Gem::Version 
        version: 0.8.2
    version: 
- !ruby/object:Gem::Dependency 
  name: cucumber
  type: :development
  version_requirement: 
  version_requirements: !ruby/object:Gem::Requirement 
    requirements: 
    - - ">="
      - !ruby/object:Gem::Version 
        version: 1.1.13
    version: 
- !ruby/object:Gem::Dependency 
  name: rspec
  type: :development
  version_requirement: 
  version_requirements: !ruby/object:Gem::Requirement 
    requirements: 
    - - ">="
      - !ruby/object:Gem::Version 
        version: "0"
    version: 
- !ruby/object:Gem::Dependency 
  name: echoe
  type: :development
  version_requirement: 
  version_requirements: !ruby/object:Gem::Requirement 
    requirements: 
    - - ">="
      - !ruby/object:Gem::Version 
        version: "0"
    version: 
description: Anti-CSRF Rack middleware
email: emanuele.vicentini@gmail.com
executables: []

extensions: []

extra_rdoc_files: 
- LICENSE.rdoc
- README.rdoc
files: 
- cucumber.yml
- example/app.rb
- example/config-with-raise.ru
- example/config.ru
- example/views/form.erb
- example/views/form_not_working.erb
- example/views/response.erb
- features/browser_only.feature
- features/empty_responses.feature
- features/raising_exception.feature
- features/setup.feature
- features/skip_some_routes.feature
- features/step_definitions/request_steps.rb
- features/step_definitions/response_steps.rb
- features/step_definitions/setup_steps.rb
- features/support/env.rb
- features/variation_on_field_name.feature
- lib/rack/csrf.rb
- lib/rack/vendor/securerandom.rb
- LICENSE.rdoc
- Manifest
- rack_csrf.gemspec
- Rakefile
- README.rdoc
- spec/csrf_spec.rb
- spec/spec.opts
- spec/spec_helper.rb
has_rdoc: true
homepage: http://github.com/baldowl/rack_csrf
licenses: []

post_install_message: 
rdoc_options: 
- --line-numbers
- --inline-source
- --title
- Rack_csrf
- --main
- README.rdoc
require_paths: 
- lib
required_ruby_version: !ruby/object:Gem::Requirement 
  requirements: 
  - - ">="
    - !ruby/object:Gem::Version 
      version: "0"
  version: 
required_rubygems_version: !ruby/object:Gem::Requirement 
  requirements: 
  - - ">="
    - !ruby/object:Gem::Version 
      version: "1.2"
  version: 
requirements: []

rubyforge_project: rackcsrf
rubygems_version: 1.3.3
specification_version: 3
summary: Anti-CSRF Rack middleware
test_files: []
