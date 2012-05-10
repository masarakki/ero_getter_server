$:.unshift(File.expand_path(File.dirname(__FILE__)))

class Downloader
  autoload :Queue, 'downloader/queue'
  autoload :Base, 'downloader/base'
  autoload :ErogazouSokuhou, 'downloader/erogazou_sokuhou'
  autoload :NijigazouSokuhou, 'downloader/nijigazou_sokuhou'
  autoload :WakutekaSokuhou, 'downloader/wakuteka_sokuhou'
  autoload :KibonNu, 'downloader/kibon_nu'
  autoload :GazouSokuhou, 'downloader/gazou_sokuhou'
  autoload :MoeMink, 'downloader/moe_mink'

  autoload :PmStyle, 'downloader/pm_style'
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

  def self.pid_file
    File.join(base_path, '.pid')
  end

  def self.download(url)

    if url =~ /http:\/\/hot-kuma-vip\.net\/archives\/\d+\.html/
      Downloader::ErogazouSokuhou.new(url).run
    elsif url =~ /http:\/\/nijigazo\.2chblog\.jp\/archives\/\d+.html/
      Downloader::NijigazouSokuhou.new(url).run
    elsif url =~ /http:\/\/blog\.livedoor\.jp\/wakusoku\/archives\/\d+\.html/
      Downloader::WakutekaSokuhou.new(url).run
    elsif url =~ /http:\/\/kibonnnu\.2chblog\.jp\/archives\/\d+\.html/
      Downloader::KibonNu.new(url).run
    elsif url =~ /http:\/\/stalker\.livedoor\.biz\/archives\/\d+\.html/
      Downloader::GazouSokuhou.new(url).run
    elsif url =~ /http:\/\/mogavip\.com\/archives\/\d+\.html/
      Downloader::MoeMink.new(url).run
    elsif url =~ /http:\/\/mxserver08\.net\/new_pm\/main\/movie\d+\.html/
      Downloader::PmStyle.new(url).run
    elsif url =~ /http:\/\/www\.100-erobyte\.com\/main\/movie\d+\.html/
      Downloader::Erobyte.new(url).run
    end
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
    elsif url =~ /http:\/\/nijigazo\.2chblog\.jp\/archives\/\d+.html/
      Downloader::NijigazouSokuhou
    elsif url =~ /http:\/\/blog\.livedoor\.jp\/wakusoku\/archives\/\d+\.html/
      Downloader::WakutekaSokuhou
    elsif url =~ /http:\/\/kibonnnu\.2chblog\.jp\/archives\/\d+\.html/
      Downloader::KibonNu
    elsif url =~ /http:\/\/stalker\.livedoor\.biz\/archives\/\d+\.html/
      Downloader::GazouSokuhou
    elsif url =~ /http:\/\/mogavip\.com\/archives\/\d+\.html/
      Downloader::MoeMink
    elsif url =~ /http:\/\/mxserver08\.net\/new_pm\/main\/movie\d+\.html/
      Downloader::PmStyle
    elsif url =~ /http:\/\/www\.100-erobyte\.com\/main\/movie\d+\.html/
      Downloader::Erobyte
    else
      nil
    end
  end
end
