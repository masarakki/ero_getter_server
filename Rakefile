task :default => :spec

$:.unshift(File.expand_path(File.dirname(__FILE__) + '/lib'))

require 'ero_getter_server'
require 'rspec/core'
require 'rspec/core/rake_task'
require 'resque/tasks'

RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = FileList['spec/**/*_spec.rb']
end

desc 'start server'
task 'start' do
  puts 'start'
  Rake::Task['backend:start'].invoke
  Rake::Task['front:start'].invoke
end

namespace :front do
  desc 'start frontend server'
  task :start do
    `shotgun`
  end
end

namespace :backend do
  desc 'start backend task'
  task :start do
    if File.exists?(EroGetter::Downloader.pid_file)
      pid = File.read(EroGetter::Downloader.pid_file)
      if pid && `ps --pid #{pid} | grep ruby` != ''
        puts "backend task is already running: pid = #{pid}"
      else
        `ruby ./bin/daemon.rb`
      end
    else
      `ruby ./bin/daemon.rb`
    end
  end

  desc 'stop backend task'
  task :stop do
    if File.exists? EroGetter::Downloader.pid_file
      pid = File.read EroGetter::Downloader.pid_file
      if pid
        `kill #{pid}`
        `rm #{EroGetter::Downloader.pid_file}`
      end
    end
  end

  desc 'restart backend task'
  task :restart do
    Rake::Task['backend:stop'].invoke
    Rake::Task['backend:start'].invoke
  end
end
