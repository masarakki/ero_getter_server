class EroGetter::Downloader::ErogazouSokuhou < EroGetter::Downloader::Base
  def dirname
    unless @dirname
      url =~ /http:\/\/hot-kuma-vip.net\/archives\/([0-9]+)\.html/
      @dirname = File.expand_path(File.join(base_path, "erogazou_sokuhou" , $1))
      mkdir(@dirname) unless File.exists?(@dirname)
    end
    @dirname
  end

  def run
    document = Nokogiri::HTML(open(url).read)

    urls = document.css("#jquery-image-zoom-example02 a > img").map { |xpath|
      xpath.parent[:href] if xpath.parent[:href] =~ /\.jpe?g|gif|png$/
    }.compact

    client = HTTPClient.new

    urls.each_with_index do |image_url, index|
      ext = image_url.split(".").last
      filename = "%04d.%s" % [index, ext]
      response = client.get(image_url)
      raise unless response.status == 200
      File.open(File.join(dirname, filename), "wb") {|f| f.write response.body }
    end
  end
end

