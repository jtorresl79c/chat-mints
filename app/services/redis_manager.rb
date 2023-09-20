class RedisManager
  attr_accessor :redis_server

  ##
  # Manager constructor
  def initialize
    # get mints config
    template = ERB.new File.new("#{Rails.root}/mints_config.yml.erb").read
    config = YAML.safe_load template.result(binding)
    @redis_server = Redis.new(host: config['redis_cache']['redis_host'], db: config['redis_cache']['redis_db'])
  end

  ##
  # This method save response in redis cache for every kind
  # of statistic
  def save_cache(key, data, time = 24)
    # time parameter is in hours
    redis_server.setex(key, time * 3600, data)
  end

  ##
  # Verify if the requested data exists in redis
  def get_cache(key)
    redis_server.get(key)
  end

  ##
  # Delete all keys from redis
  def flushall
    redis_server.flushall
  end
end
