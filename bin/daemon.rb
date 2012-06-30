#!/usr/bin/env ruby

require 'logger'
require_relative '../lib/downloader'
require 'ero_getter'

log = Logger.new('log/daemon.log')
log.level = Logger::WARN

Process.daemon
pid = File.open(Downloader.pid_file, 'w') do |f|
  f.write Process.pid
end

def ero_getter
  @ero_getter ||= EroGetter.new
end

def downloader
  @downloader ||= Downloader.new
end

loop do
  begin
    url = downloader.queue.pop
    append = false
    if url
      url.strip!
      begin
        if klass = ero_getter.detect(url)
          klass.new(url).run
        else
          Downloader.download(url)
        end
      rescue => e
        log.warn e
        append = true
      ensure
        downloader.queue.push url if append
      end
    else
      sleep 5
    end
  rescue => e
    log.warn e
  end
end
