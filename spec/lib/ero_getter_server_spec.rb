require 'spec_helper'

describe EroGetter do
  it { EroGetter.const_defined?(:Server).should be_true }

  describe :instance_methods do
    subject { EroGetter.new }
    its(:downloader) { should be_a EroGetter::Downloader }
    describe :detect do
      it "method chain" do
        subject.stub(:detect_without_downloader).and_return(nil)
        subject.downloader.should_receive(:strategy).and_return(true)
        subject.detect('unko')
      end
    end
  end
end
