require_relative 'lib/downloader'

desc 'start server'
task 'start' do
  puts 'start'
end

namespace :backend do
  desc 'start backend task'
  task :start do
    if File.exists? Downloader.pid_file
      pid = File.read Downloader.pid_file
      if pid
        puts "backend task is already running: pid = #{pid}"
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
