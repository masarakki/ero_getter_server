class Downloader::KibonNu < Downloader::Base
  def dirname
    unless @dirname
      url =~ /http:\/\/kibonnnu\.2chblog\.jp\/archives\/([0-9]+)\.html/
      @dirname = File.expand_path(File.join(base_path, "kibon_nu" , $1))
      mkdir(@dirname) unless File.exists?(@dirname)
    end
    @dirname
  end

  def run
    document = Nokogiri::HTML(open(url).read)
    image_urls = document.css(".articleInner img").map { |path|
      if path.parent.name == 'a' && path.parent[:href] =~ /jpe?g|gif|png$/
        path.parent[:href]
      else
        path[:src]
      end
    }.compact

    client = HTTPClient.new
    image_urls.each_with_index do |image_url, index|
      ext = image_url.split(".").last
      filename = "%04d.%s" % [index, ext]
      response = client.get(image_url, :header => {:referer => url}, :follow_redirect => true)
      raise unless response.status == 200
      File.open(File.join(dirname, filename), "wb") {|f| f.write response.body }
    end
  end
end
