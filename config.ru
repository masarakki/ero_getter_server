$:.unshift(File.expand_path(File.dirname(__FILE__) + '/lib'))
require 'ero_getter_server'
require 'resque/server'
require 'logger'

logger = Logger.new(STDOUT)
class Logger
  alias write <<
end

map '/queue' do
  run Resque::Server
end

use Rack::CommonLogger, logger
run EroGetter::Server
