require 'rake/clean'
require 'cucumber/rake/task'
require 'rspec/core/rake_task'
require 'rdoc/task'
require 'jeweler'

Cucumber::Rake::Task.new :features
task :features => :check_dependencies
task :default => :features

RSpec::Core::RakeTask.new :spec
task :spec => :check_dependencies
task :default => :spec

version = File.exists?('VERSION') ? File.read('VERSION').strip : ''

RDoc::Task.new :doc do |rdoc|
  rdoc.rdoc_dir = 'doc'
  rdoc.title = "Rack::Csrf #{version}"
  rdoc.main = 'README.rdoc'
  rdoc.rdoc_files.include('README.rdoc', 'LICENSE.rdoc')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

Jeweler::Tasks.new do |gem|
  gem.name = 'rack_csrf'
  gem.summary = 'Anti-CSRF Rack middleware'
  gem.description = 'Anti-CSRF Rack middleware'
  gem.license = 'MIT'
  gem.authors = 'Emanuele Vicentini'
  gem.email = 'emanuele.vicentini@gmail.com'
  gem.homepage = 'https://github.com/baldowl/rack_csrf'
  gem.rubyforge_project = 'rackcsrf'
  gem.add_dependency 'rack', '>= 0.9'
  gem.add_development_dependency 'cucumber', '>= 0.1.13'
  gem.add_development_dependency 'rack-test'
  gem.add_development_dependency 'rspec', '>= 2.0.0'
  gem.add_development_dependency 'rdoc', '>= 2.4.2'
  gem.rdoc_options << '--line-numbers' << '--inline-source' << '--title' <<
    "Rack::Csrf #{version}" << '--main' << 'README.rdoc'
  gem.test_files.clear
end

Jeweler::GemcutterTasks.new

desc <<-EOD
Shows the changelog in Git between the given points.

start -- defaults to the current version tag
end   -- defaults to HEAD
EOD
task :changes, [:start, :end] do |t, args|
  args.with_defaults :start => "v#{Rake.application.jeweler.version}",
    :end => 'HEAD'
  repo = Git.open Rake.application.jeweler.git_base_dir
  repo.log(nil).between(args.start, args.end).each do |c|
    puts c.message.split($/).first
  end
end
