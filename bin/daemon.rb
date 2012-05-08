#!/usr/bin/env ruby

require 'logger'
require_relative '../lib/downloader'

Process.daemon
pid = File.open(Downloader.pid_file, 'w') do |f|
  f.write Process.pid
end

loop do
  begin
    urls = File.readlines(Downloader.queue_file)
    url = urls.shift
    append = false
    if url
      begin
        Downloader.download(url.strip)
      rescue => e
        LOG.warn e
        append = true
      ensure
        File.open(Downloader::queue_file, "r+") do |f|
          f.flock(File::LOCK_EX)
          urls = f.readlines.select { |target| target != url }
          urls.push url if append
          f.rewind
          f.truncate 0
          f.write urls.join()
          f.flush
        end
      end
    else
      sleep 5
    end
  rescue => e
    LOG.warn e
  end
end
