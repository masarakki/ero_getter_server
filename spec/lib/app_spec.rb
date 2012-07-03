require 'spec_helper'
require 'app'

describe EroGetter::Server do

  let(:downloader) { Downloader.new }
  let(:ero_getter) { EroGetter.new }

  before do
    downloader
    ero_getter
    Downloader.stub(:new).and_return(downloader)
    EroGetter.stub(:new).and_return(ero_getter)
  end

  describe 'GET /' do
    it "assigns @queues" do
      downloader.queue.should_receive(:list).and_return(['http://example.com/1.html', 'http://example.com/2.html'])
      get '/'
    end

    it "assigns @sites" do
      EroGetter.should_receive(:url_mapping).and_return({:hoge => :item1, :hage => :item2})
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
        downloader.queue.stub(:push).and_return(true)
        downloader.stub(:strategy).and_return(nil)
      end

      it "error response" do
        downloader.should_receive(:strategy).with(url).and_return(nil)
        post '/', :url => url
        last_response.ok?.should be_false
      end

      it "not queued" do
        downloader.queue.should_not_receive(:push)
        post '/', url: url
      end
    end

    context :with_valid_url do
      before do
        downloader.queue.stub(:push).and_return(true)
        downloader.stub(:strategy).and_return(true)
      end

      context :under_ero_getter do
        it "check by ero_getter first" do
          ero_getter.should_receive(:detect).with(url).and_return(true)
          downloader.should_not_receive(:strategy).with(url)
          post '/', url: url
          last_response.ok?.should be_true
        end
      end

      context :under_downloder do
        it "check by downloader" do
          ero_getter.should_receive(:detect).with(url).and_return(false)
          downloader.should_receive(:strategy).with(url).and_return(true)
          post '/', url: url
          last_response.ok?.should be_true
        end
      end

      it "queue url" do
        downloader.queue.should_receive(:push).with(url)
        post '/', url: url
      end
    end
  end
end
