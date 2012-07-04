require 'ero_getter'
require 'active_support/core_ext'

class EroGetter
  autoload :Server, 'ero_getter/server'
  autoload :Queue, 'ero_getter/queue'
  autoload :Downloader, 'ero_getter/downloader'

  def queue
    @queue ||= EroGetter::Queue.new
  end

  def downloader
    @downloader ||= EroGetter::Downloader.new
  end

  def detect_with_downloader(url)
    detect_without_downloader(url) || downloader.strategy(url)
  end

  alias_method_chain :detect, :downloader
end
