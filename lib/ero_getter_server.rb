require 'ero_getter'
require 'active_support/core_ext'

class EroGetter
  autoload :Server, 'ero_getter/server'
  autoload :Job, 'ero_getter/job'
  autoload :Downloader, 'ero_getter/downloader'

  def downloader
    @downloader ||= EroGetter::Downloader.new
  end

  def detect_with_downloader(url)
    detect_without_downloader(url) || downloader.strategy(url)
  end

  alias_method_chain :detect, :downloader
end
