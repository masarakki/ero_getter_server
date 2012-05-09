#!/usr/bin/env ruby

require 'logger'
require_relative '../lib/downloader'

Process.daemon
pid = File.open(Downloader.pid_file, 'w') do |f|
  f.write Process.pid
end

def downloader
  @downloader ||= Downloader.new
end

loop do
  begin
    url = downloader.queue.pop
    append = false
    if url
      begin
        Downloader.download(url.strip)
      rescue => e
        LOG.warn e
        append = true
      ensure
        downloader.queue.push url if append
      end
    else
      sleep 5
    end
  rescue => e
    LOG.warn e
  end
end
