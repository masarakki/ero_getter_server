require 'spec_helper'

describe EroGetter::Server do
  let(:ero_getter) { EroGetter.new }

  before do
    ero_getter
    EroGetter.stub(:new).and_return(ero_getter)
  end

  describe 'GET /' do
    it "assigns @queues" do
      Resque.should_receive(:size).with(:ero_getter).and_return :size
      get '/'
    end
    it "assigns @sites" do
      EroGetter.should_receive(:url_mapping).and_return({:hoge => NijigazouSokuhou})
      get '/'
    end
  end

  describe 'POST /' do
    let(:url) { 'http://example.com/1.html' }

    context :without_url do
      it "error response" do
        post '/'
        last_response.should_not be_ok
      end
    end

    context :with_invalid_url do
      before do
        ero_getter.downloader.stub(:strategy).and_return(nil)
      end

      it "error response" do
        ero_getter.should_receive(:detect).with(url).and_return(nil)
        post '/', :url => url
        last_response.ok?.should be_false
      end

      it "not queued" do
        Resque.should_not_receive(:enqueue)
        post '/', url: url
      end
    end

    context :with_valid_url do
      before do
        Resque.stub(:enqueue).and_return(true)
        ero_getter.stub(:detect).and_return(true)
      end

      it "push queue" do
        ero_getter.should_receive(:detect).with(url).and_return(true)
        post '/', url: url
        last_response.ok?.should be_true
      end

      it "queue url" do
        Resque.should_receive(:enqueue).with(EroGetter::Job, url)
        post '/', url: url
      end
    end
  end
end
