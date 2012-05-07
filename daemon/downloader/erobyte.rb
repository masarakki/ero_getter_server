# -*- coding: utf-8 -*-
require 'kconv'

class Downloader::Erobyte < Downloader::Base
  def dirname(image_url = nil)
    path = image_url.match(/\/([a-zA-Z_0-9]+).\.zip$/)
    dirname = File.join(base_path, 'erobyte', path[1])
    mkdir(dirname) unless File.exists?(dirname)
    dirname
  end

  def client
    @client ||= HTTPClient.new
  end

  def run
    document = Nokogiri::HTML(open(url).read.toutf8)
    file_urls = document.css("#mov #download a").map {|path|
      path[:href]
    }

    dir = dirname(file_urls.first)

    file_urls.each do |file_url|
      response = client.get(file_url, :header => {:referer => url}, :follow_redirect => true)
      raise unless response.status == 200
      unzip(response.body).each do |filename, data|
        File.open(File.join(dir, filename), "wb") {|f| f.write data }
      end
    end
  end
end
