# -*- coding: utf-8 -*-
class Downloader::NijigazouSokuhou < Downloader::Base
  def dirname(image_url = nil)
    path = image_url.split('/')
    d = path[3..5].join('')
    chara = path[6]
    dirname = File.join(base_path, 'nijigazou_sokuhou', chara, d)
    mkdir(dirname) unless File.exists?(dirname)
    dirname
  end

  def run
    fetch_url(url)
  end

  def client
    @client ||= HTTPClient.new
  end

  def fetch_url(src_url, dist = 0)
    document = Nokogiri::HTML(open(src_url).read)

    title_full = document.title
    title = title_full.split(/:/).last.match(/(.+?)(その.+)?$/)[1].strip.gsub(/&amp;/, '&')

    image_urls = document.css(".article-body-more > a > img").map { |path|
      path.parent[:href] if path.parent[:href] =~ /jpe?g|png|gif$/
    }.compact

    connection = {:prev => document.xpath("//a[@rel='prev']").first, :next => document.xpath("//a[@rel='next']").first}
    dir = dirname(image_urls.first)


    image_urls.each do |image_url|
      filename = File.basename(image_url)
      response = client.get(image_url, :header => {:referer => src_url})
      raise unless response.status == 200
      File.open(File.join(dir, filename), "wb") {|f| f.write response.body }
    end

    connection.each do |type, path|
      if path
        case type
        when :prev
          fetch_url(path[:href], -1) if dist <= 0 && path.text.match(Regexp.escape(title))
        when :next
          fetch_url(path[:href],  1) if dist >= 0 && path.text.match(Regexp.escape(title))
        end
      end
    end
  end
end
