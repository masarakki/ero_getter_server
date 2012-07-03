require 'spec_helper'

describe EroGetter do
  it { EroGetter.const_defined?(:Server).should be_true }
end
