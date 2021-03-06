require 'redis'

class RedisService
  include LoggerHelper
  attr_reader :redis
  def initialize
    @redis = Redis.new
  end

  def [](key)
    log("reading with key: '#{key}'") do
      result = redis[key.to_s]
      result ? JSON.parse(result, symbolize_names: true) : nil
    end
  end

  def []=(key, value)
    log("writing with key: '#{key}'") do
      redis.set(key.to_s, value.to_json, ex: 32.days.to_i)
      value
    end
  end

  def fetch(key, value = nil)
    result = self[key]
    return result if result
    self[key] = (value || yield)
    self[key]
  end

  def flushall
    redis.flushall
  end
end