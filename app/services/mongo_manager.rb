class MongoManager
  ##
  # Manager constructor
  def initialize; end

  ##
  # This method save response in mongo cache for every kind
  # of statistic
  def save_cache(key, data, date, redis_key, redis_time = 24)
    StatisticsCache.create(
      stats_type: key,
      cache: data,
      redis_cache_key: redis_key || key,
      redis_cache_time: redis_time,
      date_config: date,
    )
  end

  ##
  # Verify if the requested data exists in mongo
  def get_cache(redis_key)
    StatisticsCache.where(redis_cache_key: redis_key).first
  end

  ##
  # Verify if the requested data exists in mongo depending on their config date
  def delete_cache_by_key_and_date(key, months = 2)
    current_date = DateTime.now
    StatisticsCache.where(stats_type: key,
                          created_at: (current_date - months.months)..(current_date + 1.day)).delete_all
  end
end
