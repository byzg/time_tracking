class BaseCollection < Array
  protected
  def lazy_find(param)
    find(param) || (pull && find(param)) || (pull! && find(param))
  end

  def find(param)
    detect {|obj| obj[find_param] == param }
  end

  def load
    raise NotImplementedError
  end

  def redis_key
    raise NotImplementedError
  end

  def pull
    config.redis_service
      .fetch(redis_key) { load }
      .each do |obj|
        push(obj) unless find(obj[find_param])
      end
  end

  def pull!
    config.redis_service[redis_key] = load
    pull
  end
end