require 'sinatra/base'
require 'resque'

class EroGetter
  class Server < Sinatra::Base
    set :root, File.expand_path(File.dirname(__FILE__) + '/../..')
    enable :logging

    def ero_getter ; @ero_getter ||= EroGetter.new ; end
    def worker
      @worker ||= Resque.workers.find do |worker|
        worker.queues.grep /ero_getter/
      end
    end

    def queues
      Resque.size :ero_getter
    end

    get '/' do
      @sites = EroGetter.url_mapping.map(&:last)
      @worker = worker
      @queues = queues
      haml :index
    end

    post '/' do
      if params[:url] && ero_getter.detect(params[:url])
        Resque.enqueue(EroGetter::Job, params[:url])
        [200, 'success']
      else
        [403, 'invalid url']
      end
    end
  end
end
