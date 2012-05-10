require 'spec_helper'
require 'downloader'

describe Downloader do
  subject { @downloader }
  before { @downloader = Downloader.new }

  describe :strategy do
    it { subject.strategy('http://nijigazo.2chblog.jp/').should be_nil }
    it { subject.strategy('http://nijigazo.2chblog.jp/archives/52249642.html').should == Downloader::NijigazouSokuhou }
  end
end
