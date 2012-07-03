require 'ero_getter_server'
require 'rack/test'

RSpec.configure do |config|
  config.include Rack::Test::Methods
  def app
    EroGetter::Server
  end
end
