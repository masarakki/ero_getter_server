require 'spec_helper'

describe EroGetter::Downloader do
  subject { @downloader }
  before { @downloader = EroGetter::Downloader.new }

  describe :strategy do
    it { subject.strategy('http://nijigazo.2chblog.jp/').should be_nil }
    it { subject.strategy('http://hot-kuma-vip.net/archives/10101010.html').should == EroGetter::Downloader::ErogazouSokuhou }
  end
end
