module CacheMethods
    extend ActiveSupport::Concern

    included do
        before_action :set_managers
    end

    def manage_data(method_key, cache_id, dates, method_to_call, *args)
        cached_value, found = has_cached_value(cache_id)

        unless found
            cached_value = method_to_call.call(*args)
            
            catch_response_method(method_key, cached_value, (dates || @default_dates), cache_id)

            cached_value
        end

        cached_value
    end

    def has_cached_value(cache_id)
        processed_key = process_key(cache_id)
        cache = @redis_manager.get_cache(processed_key)
        cached_value = nil
        found = nil

        if cache
            found = true
            cached_value = JSON.parse(cache)['cached_value']
        else
            mongo_cache = @mongo_manager.get_cache(processed_key)
            
            if mongo_cache
                @redis_manager.save_cache(
                    mongo_cache.redis_cache_key,
                    mongo_cache.cache,
                    mongo_cache.redis_cache_time
                )

                cached_value = JSON.parse(mongo_cache.cache)['cached_value']
                found = true
            end
        end

        [cached_value, found]
    end

    def catch_response_method(id, value, date, redis_key, redis_time = 24)
        @mongo_manager.save_cache(id, { cached_value: value }.to_json, date.as_json, process_key(redis_key), redis_time)
    end

    private

    def set_managers
        @redis_manager = DynamicCacheManager.new('redis')
        @mongo_manager = DynamicCacheManager.new('mongo')
        @default_dates = { start: DateTime.now, end: DateTime.now + 1.day }
    end

    def process_key(key)
        ActiveSupport::Inflector.transliterate(key.downcase.gsub('-', '_').gsub(' ', '_')).to_s
    end
end