#!/usr/bin/env ruby

require 'sinatra'
require_relative '../lib/downloader'

def bin_dir
  "#{ENV['HOME']}/Dropbox/bin"
end

def downloader
  @downloader ||= Downloader.new
end

get '/' do
  @pid = `ruby #{bin_dir}/dget.rb pid`
  @queues = downloader.queue.list
  haml :index
end

post '/' do
  downloader.queue.push params[:url] if params[:url]
  'success'
end
