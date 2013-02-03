require 'spec_helper'

describe EroGetter::Job do
  it "test" do
    EroGetter::Downloader.should_receive(:download).with(:url)
    EroGetter::Job.perform(:url)
  end
end
