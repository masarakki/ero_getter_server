task :default => :spec

require 'rspec/core'
require 'rspec/core/rake_task'
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
    if File.exists?(Downloader.pid_file)
      pid = File.read(Downloader.pid_file)
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
    if File.exists? Downloader.pid_file
      pid = File.read Downloader.pid_file
      if pid
        `kill #{pid}`
        `rm #{Downloader.pid_file}`
      end
    end
  end
end
