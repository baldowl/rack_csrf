require 'rake/clean'
require 'cucumber/rake/task'
require 'spec/rake/spectask'

task :default => [:features, :spec]

Cucumber::Rake::Task.new do |c|
  c.cucumber_opts = '--profile default'
end

Spec::Rake::SpecTask.new do |t|
  t.spec_opts = %w(-O spec/spec.opts)
end
