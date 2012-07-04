require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'httpclient'
require 'zipruby'
require 'digest/md5'

class EroGetter::Downloader::Base
  attr_reader :url

  def initialize(url)
    @url = url
  end

  def base_path
    EroGetter::Downloader.base_path
  end

  def mkdir(path)
    basedir = File.dirname(path)
    mkdir(basedir) unless File.exists?(basedir)
    Dir.mkdir(path)
  end

  def unzip(zip_data)
    result = []
    Zip::Archive.open_buffer(zip_data) do |archive|
      archive.num_files.times do |i|
        entry_name = archive.get_name(i)
        archive.fopen(entry_name) do |f|
          result << [f.name, f.read]
        end
      end
    end
    result
  end
end
