Rails.application.routes.draw do

  

  if ENV['PROJECT_STAGE'] === 'maintenance'

    if ENV.fetch('USE_MULTI_LANGUAGE', false).to_s.downcase.strip === 'true'
      scope '(:locale)', locale: /#{%w[en es].join('|')}/, :defaults => { :locale => 'es'} do
        get '/', to: 'closed#index', as: :home
      end
    else
      get '/', to: 'closed#index', as: :home
    end

  else

    if ENV.fetch('USE_MULTI_LANGUAGE', false).to_s.downcase.strip === 'true'

      root 'application#manage_url_without_lang'

      # If you have multi-language, you can enable this kind of routes
      # This generate routes like:
      # To change or add routes, check en.yml and es.yml
      # /es/blog/:slug
      # /en/blog/:slug

      locales = I18n.available_locales.map(&:to_s)

      scope '(:locale)', locale: /#{locales.join('|')}/, :defaults => { :locale => 'es'} do
        locales.each do |locale|
          I18n.t('routes', { locale: locale }).keys.each do |controller|
            I18n.t("routes.#{controller.to_s}", { locale: locale }).keys.each do |action|
              get "/#{I18n.t("routes.#{controller.to_s}.#{action.to_s}", { locale: locale }) }", to: "#{controller.to_s}##{action.to_s}"
            end
          end

          get '/404', to: 'error#not_found'
        end
      end

    else
      get '/', to: 'home#index', as: :home
      # Permit routes for vue-router
      

      get  '/terminos-y-condiciones' => 'terms_and_conditions#index', as: :terms
      get '/blog/:slug' => 'blog#show', as: :detailed_blog
    end

    match '/public-assets/*path' => 'mints_assets#index', via: [:get]

    scope :settings do
      get '/', to: 'settings#index', as: :home_settings
      get '/login' => 'settings#login'
      get '/logout' => 'settings#logout'

      # Permit routes for vue-router
      get '', to: 'settings#index'
      get '*', to: 'settings#index'
      get '*a', to: 'settings#index'
    end

    # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

    # Custom API request endpoints
    namespace :api, path: '/api' do
      post 'login', to: "login#login"
      post 'createdmessagehook', to: "webhooks#created_message"
      get 'createdmessagehook', to: "webhooks#created_message"
      post 'register', to: "login#register" # post NombreDelLink, to: "controller#nombreDelAction"
      get 'prueba', to: "login#prueba"
      post 'createrandomuser', to: "login#create_random_user"
      get 'contact/magic-link-login/:hash', to:'api#magic_link_login'
      get 'user/magic-link-login/:hash', to:'api#user_magic_link_login'

      namespace :v1, path: '/v1' do
        post '/login/check-email', to:'login#check_email'
        post '/login/send-magic-link', to: 'login#contact_send_magic_link'

        namespace :settings do
          post '/login-password', to: 'login#login_password'
          post '/magic-link-login', to: 'login#magic_link_login'

          resources :contacts
        end
      end

    end
    get '', to: 'home#index'
      get '*', to: 'home#index'
      get '*a', to: 'home#index'
    # Set cookie (Share cookies between domains)
    get '/set-cookie' => 'cookie_setter#set_cookie'
  end

  if ENV.fetch('USE_MULTI_LANGUAGE', false).to_s.downcase.strip === 'true'

    # Redirect 404
    scope '(:locale)', locale: /#{['en'].join('|')}/ do
      get '*', to: redirect('/en/404')
      get '*a', to: redirect('/en/404')
    end

    get '*', to: redirect('/es/404')
    get '*a', to: redirect('/es/404')

  else
    # Redirect 404
    get '*', to: redirect('/404')
    get '*a', to: redirect('/404')
  end

  
end