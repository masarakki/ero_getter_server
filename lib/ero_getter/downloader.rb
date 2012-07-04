class EroGetter::Downloader
  autoload :Base, 'ero_getter/downloader/base'
  autoload :ErogazouSokuhou, 'ero_getter/downloader/erogazou_sokuhou'
  autoload :KibonNu, 'ero_getter/downloader/kibon_nu'
  autoload :MoeMink, 'ero_getter/downloader/moe_mink'

  autoload :Erobyte, 'ero_getter/downloader/erobyte'

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
      EroGetter::Downloader::ErogazouSokuhou
    elsif url =~ /http:\/\/kibonnnu\.2chblog\.jp\/archives\/\d+\.html/
      EroGetter::Downloader::KibonNu
    elsif url =~ /http:\/\/mogavip\.com\/archives\/\d+\.html/
      EroGetter::Downloader::MoeMink
    elsif url =~ /http:\/\/www\.100-erobyte\.com\/main\/movie\d+\.html/
      EroGetter::Downloader::Erobyte
    else
      nil
    end
  end
end
