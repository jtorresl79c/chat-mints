class DynamicCacheManager
  attr_accessor :provider

  def initialize(provider = nil)
    supported_providers = %w[redis mongo]
    @provider = supported_providers.include?(provider) ? "#{provider}_manager".camelize.constantize.new : RedisManager.new
  end

  ##
  # This method save response in mongo cache for every kind
  # of statistic
  def save_cache(*args)
    provider.save_cache(*args)
  end

  ##
  # Verify if the requested data exists in mongo
  def get_cache(*args)
    provider.get_cache(*args)
  end

  ##
  # Set method missing function to prevent call any other 
  # functions that has not been defined
  # TODO:RuboCop: When using `method_missing`, define `respond_to_missing?`. [Style/MissingRespondToMissing]
  def method_missing(m, *args, &block)
    'The requested method doesn\'t exists'
  end
end
