require 'spec_helper'

describe EroGetter::Server do
  describe 'GET /' do
    it "assigns @queues" do
      expect(Resque).to receive(:size).with(:ero_getter).and_return :size
      get '/'
    end

    it "assigns @sites" do
      expect(EroGetter).to receive(:url_mapping).and_return({:hoge => NijigazouSokuhou})
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
      before { allow(EroGetter).to receive(:detect).and_return(nil) }

      it "error response" do
        expect(EroGetter).to receive(:detect).with(url).and_return(nil)
        post '/', :url => url
        expect(last_response).not_to be_ok
      end

      it "not queued" do
        expect(Resque).not_to receive(:enqueue)
        post '/', url: url
      end
    end

    context :with_valid_url do
      before do
        allow(Resque).to receive(:enqueue).and_return(true)
        allow(EroGetter).to receive(:detect).and_return(true)
      end

      it "push queue" do
        expect(EroGetter).to receive(:detect).with(url).and_return(true)
        post '/', url: url
        expect(last_response).to be_ok
      end

      it "queue url" do
        expect(Resque).to receive(:enqueue).with(EroGetter::Job, url)
        post '/', url: url
      end
    end
  end
end
