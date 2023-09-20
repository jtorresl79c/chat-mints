class CookieSetterController < ActionController::Base
  def set_cookie
    # Load mints config data (host and password)
    template = ERB.new File.new("#{Rails.root}/mints_config.yml.erb").read
    config = YAML.safe_load template.result(binding)

    if params[:token] && params[:id] && config['cookies_iframe']['activated']

      cookies[:mints_contact_session_token] = 
        { value: params[:token], expires: config['cookies_iframe']['expire_time'].to_i.hour.from_now }
      cookies[:mints_contact_id] = 
        { value: params[:id], expires: config['cookies_iframe']['expire_time'].to_i.hour.from_now }

    end
  end
end
