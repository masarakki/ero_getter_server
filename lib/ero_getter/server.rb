#!/usr/bin/env ruby

$:.unshift File.dirname(__FILE__)

require 'sinatra/base'

class EroGetter
  class Server < Sinatra::Base
    set :root, File.expand_path(File.dirname(__FILE__) + '/..')
    enable :logging

    def downloader ; @downloder ||= EroGetter::Downloader.new ; end
    def ero_getter ; @ero_getter ||= EroGetter.new ; end

    get '/' do
      @pid = downloader.pid
      @queues = ero_getter.queue.list
      @sites = EroGetter.url_mapping.map(&:last)
      haml :index
    end

    post '/' do
      if params[:url] && ero_getter.detect(params[:url])
        ero_getter.queue.push params[:url]
        [200, 'success']
      else
        [403, 'invalid url']
      end
    end
  end
end
