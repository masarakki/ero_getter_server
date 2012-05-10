#!/usr/bin/env ruby

$:.unshift File.dirname(__FILE__)

require 'sinatra/base'
require 'downloader'

module EroGetter
  class Server < Sinatra::Base
    set :root, File.expand_path(File.dirname(__FILE__) + '/..')

    def bin_dir ; "#{ENV['HOME']}/Dropbox/bin" ; end
    def downloader ; @downloder ||= Downloader.new ; end

    get '/' do
      @pid = `ruby #{bin_dir}/dget.rb pid`
      @queues = downloader.queue.list
      haml :index
    end

    post '/' do
      if params[:url] && downloader.strategy(params[:url])
        downloader.queue.push params[:url]
        'success'
      else
        'fail'
      end
    end
  end
end
