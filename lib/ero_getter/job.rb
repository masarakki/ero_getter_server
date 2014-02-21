module EroGetter
  class Job
    @queue = :ero_getter

    def self.perform(url)
      EroGetter.download(url) if EroGetter.detect(url)
    end
  end
end
