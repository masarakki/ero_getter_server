class EroGetter::Downloader::MoeMink < EroGetter::Downloader::Base
  def dirname
    unless @dirname
      url =~ /http:\/\/mogavip\.com\/archives\/([0-9]+)\.html/
      @dirname = File.expand_path(File.join(base_path, "moe_mink" , $1))
      mkdir(@dirname) unless File.exists?(@dirname)
    end
    @dirname
  end

  def run
    document = Nokogiri::HTML(open(url).read)
    image_urls = document.css(".article-body-inner a > img").map { |path|
      path.parent[:href] if path.parent[:href] =~ /jpe?g|gif|png$/
    }.compact

    client = HTTPClient.new

    image_urls.each_with_index do |image_url, index|
      ext = image_url.split(".").last
      filename = "%04d.%s" % [index, ext]
      response = client.get(image_url, :headers => {:referer => url}, :follow_redirect => true)
      raise unless response.status == 200
      File.open(File.join(dirname, filename), "wb") {|f| f.write response.body }
    end
  end
end
