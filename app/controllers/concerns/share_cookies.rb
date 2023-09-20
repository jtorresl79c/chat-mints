module ShareCookies
    extend ActiveSupport::Concern

    included do
        before_action :get_cookies
    end
    
    private

    def get_cookies
        # get mints config
        template = ERB.new File.new("#{Rails.root}/mints_config.yml.erb").read
        config = YAML.load template.result(binding)
        # Create data
        @token = cookies[:mints_contact_session_token]
        @id = cookies[:mints_contact_id]
        @hosts = []

        # Load mints config data (host and password)
        if @token && @id && config['cookies_iframe']['activated'] && config['redis_cache']['use_cache']
            @redis_server = Redis.new(host: config['redis_cache']['redis_host'], db: config['redis_cache']['redis_db'])
            variable_name = config['mints']['mints_slug'] + @id
            if !@redis_server.get(variable_name)
                @hosts = config['cookies_iframe']['hosts']
                
                time = config['cookies_iframe']['expire_time'] * 3600
                
                @redis_server.setex(variable_name,time,true)
            end
        end
    end
end