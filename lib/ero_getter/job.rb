class EroGetter::Job
  @queue = :ero_getter

  def self.ero_getter
    @ero_getter ||= EroGetter.new
  end

  def self.downloader
    @downloader ||= EroGetter::Downloader.new
  end

  def self.perform(url)
    if klass = ero_getter.detect(url)
      klass.new(url).run
    else
      EroGetter::Downloader.download(url)
    end
  end
end
