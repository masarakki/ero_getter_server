require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'httpclient'
require 'zip/zip'
require 'digest/md5'

class Downloader::Base
  attr_reader :url

  def initialize(url)
    @url = url
  end

  def base_path
    Downloader.base_path
  end

  def mkdir(path)
    basedir = File.dirname(path)
    mkdir(basedir) unless File.exists?(basedir)
    Dir.mkdir(path)
  end

  def unzip(zip_data)
    tmp_file = File.join(base_path, Digest::MD5.hexdigest(zip_data))
    begin
      File.open(tmp_file, 'wb') { |f| f.write zip_data }
      result = []
      Zip::ZipInputStream.open(tmp_file) do |zip|
        while entry = zip.get_next_entry
          filename = entry.name_in(entry.name_encoding)
          if entry.file? && !filename.match(/\.(txt|html)$/)
            result << [filename, entry.get_input_stream {|f| f.read}]
          end
        end
      end
    ensure
      File.delete tmp_file if File.exists?(tmp_file)
    end
    result
  end
end
