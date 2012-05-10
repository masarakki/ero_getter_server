#!/usr/bin/env ruby

$:.unshift File.dirname(__FILE__)

require 'sinatra/base'
require 'downloader'

module EroGetter
  class Server < Sinatra::Base
    set :root, File.expand_path(File.dirname(__FILE__) + '/..')

    def downloader ; @downloder ||= Downloader.new ; end

    get '/' do
      @pid = downloader.pid
      @queues = downloader.queue.list
      haml :index
    end

    post '/' do
      if params[:url] && downloader.strategy(params[:url])
        downloader.queue.push params[:url]
        [200, 'success']
      else
        [403, 'invalid url']
      end
    end
  end
end
