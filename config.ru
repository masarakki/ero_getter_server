#\ --pid rack.pid -D
$:.unshift(File.expand_path(File.dirname(__FILE__) + '/lib'))
require 'ero_getter_server'
require 'logger'

logger = Logger.new('log/server.log')
class Logger
  alias write <<
end
use Rack::CommonLogger, logger
run EroGetter::Server
