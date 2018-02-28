require 'redis'

class RedisService
  attr_reader :redis
  def initialize
    @redis = Redis.new
  end

  def [](key)
    result = redis[key.to_s]
    result ? JSON.parse(result) : nil
  end

  def []=(key, value)
    redis.set(key.to_s, value.to_json, ex: 32.days.to_i)
    value
  end

  def fetch(key, value = nil)
    result = self[key]
    result || (self[key] = value || yield)
  end
end