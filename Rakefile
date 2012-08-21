require File.join(File.dirname(__FILE__), 'spec', 'spec_helper')
require 'rspec/core/rake_task'
require 'bundler/gem_tasks'

RSpec::Core::RakeTask.new do |task|
  task.pattern = 'spec/**/*_spec.rb'
  task.rspec_opts = ['-c', '--format=doc', '--format=Nc', '-r ./spec/spec_helper']
end

task :package do
  version = File.read('VERSION')
  `mkdir tres-#{version}`
  `cp -r js css tres-#{version}`
  `zip tres-#{version}.zip tres-#{version}`
  `rm -rf tres-#{version}`
end