require 'spec_helper'

describe EroGetter::Job do
  subject { EroGetter::Job.perform(:url) }
  context :invalid_url do
    it "ignore" do
      expect(EroGetter).to receive(:detect).with(:url).and_return(nil)
      expect { subject }.not_to raise_error
    end
  end

  context :valid_url do
    before { allow(EroGetter).to receive(:detect).with(:url).and_return(true) }
    it "download" do
      expect(EroGetter).to receive(:download).with(:url)
      subject
    end

    context "downlod failed" do
      it "raise_error" do
        allow(EroGetter).to receive(:download).with(:url).and_raise
        expect { subject }.to raise_error
      end
    end
  end
end
