# -*- coding: utf-8 -*-
require 'kconv'

class Downloader::PmStyle < Downloader::Base
  def dirname(image_url = nil)
    path = image_url.match(/(pm_.+?)(\d+)[a|b|c]\.zip$/)
    genre = path[1]
    num = "%06d"%path[2]
    dirname = File.join(base_path, 'pm_store', [genre, num].join("_"))
    mkdir(dirname) unless File.exists?(dirname)
    dirname
  end

  def client
    @client ||= HTTPClient.new
  end

  def run
    document = Nokogiri::HTML(open(url).read.toutf8)
    file_urls = document.css("a > img").select {|path|
      path[:alt] =~ /file\d+/
    }.map {|path|
      path.parent[:href]
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
