require 'spec_helper'

describe EroGetter::Server do
  let(:ero_getter) { EroGetter.new }

  before do
    ero_getter
    EroGetter.stub(:new).and_return(ero_getter)
  end

  describe 'GET /' do
    it "assigns @pid" do
      ero_getter.downloader.should_receive(:pid).and_return(100)
      get '/'
    end

    it "assigns @queues" do
      ero_getter.queue.should_receive(:list).and_return(['http://example.com/1.html', 'http://example.com/2.html'])
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
        last_response.ok?.should be_false
      end
    end

    context :with_invalid_url do
      before do
        ero_getter.queue.stub(:push).and_return(true)
        ero_getter.downloader.stub(:strategy).and_return(nil)
      end

      it "error response" do
        ero_getter.should_receive(:detect).with(url).and_return(nil)
        post '/', :url => url
        last_response.ok?.should be_false
      end

      it "not queued" do
        ero_getter.queue.should_not_receive(:push)
        post '/', url: url
      end
    end

    context :with_valid_url do
      before do
        ero_getter.queue.stub(:push).and_return(true)
        ero_getter.stub(:detect).and_return(true)
      end

      it "push queue" do
        ero_getter.should_receive(:detect).with(url).and_return(true)
        post '/', url: url
        last_response.ok?.should be_true
      end

      it "queue url" do
        ero_getter.queue.should_receive(:push).with(url)
        post '/', url: url
      end
    end
  end
end
