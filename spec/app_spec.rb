require 'spec_helper'
require 'app'

describe Sinatra::Application do
  describe 'GET /' do
    subject { last_response }
    before do
      get '/'
    end
    its(:ok?) { should be_true }
  end
end
