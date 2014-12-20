require 'rubygems'
require 'bundler/setup'

require 'rake/clean'

require 'cucumber/rake/task'
Cucumber::Rake::Task.new :features
task :default => :features

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new :spec
task :default => :spec

require 'rack/csrf/version'

require 'rdoc/task'
RDoc::Task.new :doc do |rdoc|
  rdoc.rdoc_dir = 'doc'
  rdoc.title = "Rack::Csrf #{Rack::Csrf::VERSION}"
  rdoc.main = 'README.rdoc'
  rdoc.rdoc_files.include('README.rdoc', 'LICENSE.rdoc')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

require 'bundler/gem_tasks'

require 'git'
desc <<-EOD
Shows the changelog in Git between the given points.

start -- defaults to the current version tag
end   -- defaults to HEAD
EOD
task :changes, [:start, :end] do |_, args|
  args.with_defaults :start => "v#{Rack::Csrf::VERSION}",
    :end => 'HEAD'
  repo = Git.open Dir.pwd
  repo.log(nil).between(args.start, args.end).each do |c|
    puts c.message.split($/).first
  end
end
