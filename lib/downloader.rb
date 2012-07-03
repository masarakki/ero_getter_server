$:.unshift(File.expand_path(File.dirname(__FILE__)))
require 'ero_getter'

class Downloader
  autoload :Queue, 'downloader/queue'
  autoload :Base, 'downloader/base'
  autoload :ErogazouSokuhou, 'downloader/erogazou_sokuhou'
  autoload :KibonNu, 'downloader/kibon_nu'
  autoload :MoeMink, 'downloader/moe_mink'

  autoload :Erobyte, 'downloader/erobyte'

  def queue
    @queue ||= Downloader::Queue.new
  end

  def self.base_path
    path = File.join(ENV['HOME'], 'ero_getter')
    Dir.mkdir(path) unless Dir.exists?(path)
    path
  end

  def self.queue_file
    file = File.join(base_path, '.queue')
    File.open(file, 'w').close unless File.exists?(file)
    file
  end

  def pid
    if File.exists?(self.class.pid_file)
      File.read(self.class.pid_file)
    else
      'not running'
    end
  end

  def self.pid_file
    File.join(base_path, '.pid')
  end

  def self.download(url)
    self.new.download(url)
  end

  def download(url)
    strategy = strategy(url)
    if strategy
      strategy.new(url).run
    end
  end

  def strategy(url)
    if url =~ /http:\/\/hot-kuma-vip\.net\/archives\/\d+\.html/
      Downloader::ErogazouSokuhou
    elsif url =~ /http:\/\/kibonnnu\.2chblog\.jp\/archives\/\d+\.html/
      Downloader::KibonNu
    elsif url =~ /http:\/\/mogavip\.com\/archives\/\d+\.html/
      Downloader::MoeMink
    elsif url =~ /http:\/\/www\.100-erobyte\.com\/main\/movie\d+\.html/
      Downloader::Erobyte
    else
      nil
    end
  end
end
