task :default => :spec

$:.unshift(File.expand_path(File.dirname(__FILE__) + '/lib'))

require 'ero_getter_server'
require 'rspec/core'
require 'rspec/core/rake_task'
require 'resque/tasks'

RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = FileList['spec/**/*_spec.rb']
end

