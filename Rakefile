require 'rake/clean'
require 'cucumber/rake/task'
require 'spec/rake/spectask'
require 'rake/rdoctask'
require 'jeweler'

Cucumber::Rake::Task.new :features do |c|
  c.cucumber_opts = '--profile default'
end

task :features => :check_dependencies
task :default => :features

Spec::Rake::SpecTask.new do |t|
  t.spec_opts = %w(-O spec/spec.opts)
end

task :spec => :check_dependencies
task :default => :spec

version = File.exists?('VERSION') ? File.read('VERSION').strip : ''

Rake::RDocTask.new :doc do |rdoc|
  rdoc.rdoc_dir = 'doc'
  rdoc.title = "Rack::Csrf #{version}"
  rdoc.rdoc_files.include('README.rdoc', 'LICENSE.rdoc')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

Jeweler::Tasks.new do |gem|
  gem.name = 'rack_csrf'
  gem.summary = 'Anti-CSRF Rack middleware'
  gem.description = 'Anti-CSRF Rack middleware'
  gem.email = 'emanuele.vicentini@gmail.com'
  gem.homepage = 'http://github.com/baldowl/rack_csrf'
  gem.authors = ['Emanuele Vicentini']
  gem.rubyforge_project = 'rackcsrf'
  gem.add_dependency 'rack', '>= 0.9'
  gem.add_development_dependency 'cucumber', '>= 0.1.13'
  gem.add_development_dependency 'rspec'
  gem.rdoc_options << '--line-numbers' << '--inline-source' << '--title' <<
    "Rack::Csrf #{version}" << '--main' << 'README.rdoc'
  gem.test_files.clear
end

Jeweler::RubyforgeTasks.new
Jeweler::GemcutterTasks.new
