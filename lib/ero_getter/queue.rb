require 'redis'

class EroGetter::Queue
  @@key = "download_queue"

  def initialize
    @redis = Redis.new
  end

  def push(url)
    @redis.rpush @@key, url
  end

  def pop
    @redis.lpop @@key
  end

  def list
    @redis.lrange @@key, 0, @redis.llen(@@key)
  end
end
