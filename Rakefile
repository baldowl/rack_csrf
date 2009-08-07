require 'rake/clean'
require 'cucumber/rake/task'
require 'spec/rake/spectask'
require 'echoe'

Cucumber::Rake::Task.new :features do |c|
  c.cucumber_opts = '--profile default'
end

Spec::Rake::SpecTask.new do |t|
  t.spec_opts = %w(-O spec/spec.opts)
end

Echoe.new('rack_csrf', '1.1.0') do |s|
  s.author = 'Emanuele Vicentini'
  s.email = 'emanuele.vicentini@gmail.com'
  s.summary = 'Anti-CSRF Rack middleware'
  s.runtime_dependencies = ['rack >=0.9']
  s.development_dependencies = ['rake >=0.8.2', 'cucumber >=1.1.13', 'rspec', 'echoe']
  s.need_tar_gz = false
  s.project = 'rackcsrf'
  s.gemspec_format = :yaml
  s.retain_gemspec = true
  s.rdoc_pattern = /^README|^LICENSE/
  s.url = 'http://github.com/baldowl/rack_csrf'
end

Rake::Task[:default].clear
Rake::Task.tasks.each {|t| t.clear if t.name =~ /test/}
task :default => [:features, :spec]
