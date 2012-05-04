#!/usr/bin/env ruby

require 'sinatra'

def bin_dir
  "#{ENV['HOME']}/Dropbox/bin"
end

get '/' do
  @pid = `ruby #{bin_dir}/dget.rb pid`
  @queues = `ruby #{bin_dir}/dget.rb queue`.split("\n")
  haml :index
end

post '/' do
  `ruby #{bin_dir}/dl_queue.rb #{params[:url]}` if params[:url]
end
