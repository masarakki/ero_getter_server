require File.expand_path(File.dirname(__FILE__) + '/lib/app.rb')
require 'logger'

logger = Logger.new('log/server.log')
use Rack::CommonLogger, logger
run EroGetter::Server
