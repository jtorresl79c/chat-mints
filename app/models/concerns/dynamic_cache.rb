class DynamicCache
  include Mongoid::Document
  include Mongoid::Timestamps

  after_create :insert_redis_cache
  after_update :insert_redis_cache

  field :stats_type, type: String
  field :cache, type: String
  field :redis_cache_key, type: String
  field :redis_cache_time, type: Integer, default: 24
  field :date_config, type: Hash
  
  validates_presence_of :redis_cache_key
  validates_presence_of :redis_cache_time

  validates_uniqueness_of :redis_cache_key

  private

  def insert_redis_cache
      @statistics_manager = StatisticsManager.new('redis')
      @statistics_manager.save_cache(
          self.redis_cache_key,
          self.cache,
          self.redis_cache_time
      )
  end
end