require "bundler/gem_tasks"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new

task :default => :spec
task :test => :spec

# https://simonecarletti.com/blog/2009/09/rake-console/
desc "Open an irb session preloaded with this library"
task :console do
  sh "irb -rubygems -I lib -r motion-markdown-it-plugins.rb"
end