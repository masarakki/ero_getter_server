#!/usr/bin/env ruby

$:.unshift File.expand_path(File.dirname(__FILE__) + '/../lib')

require 'ero_getter_server'
require 'logger'

log = Logger.new('log/daemon.log')
log.level = Logger::WARN

Process.daemon
pid = File.open(EroGetter::Downloader.pid_file, 'w') do |f|
  f.write Process.pid
end

def ero_getter
  @ero_getter ||= EroGetter.new
end

def downloader
  @downloader ||= EroGetter::Downloader.new
end

loop do
  begin
    url = ero_getter.queue.pop
    append = false
    if url
      url.strip!
      begin
        if klass = ero_getter.detect(url)
          klass.new(url).run
        else
          EroGetter::Downloader.download(url)
        end
      rescue => e
        log.warn e
        append = true
      ensure
        ero_getter.queue.push url if append
      end
    else
      sleep 5
    end
  rescue => e
    log.warn e
  end
end
