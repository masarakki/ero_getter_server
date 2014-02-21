require 'spec_helper'

describe EroGetter do
  it { expect(EroGetter).to be_const_defined :Server }
  it { expect(EroGetter).to be_const_defined :Job }
end
