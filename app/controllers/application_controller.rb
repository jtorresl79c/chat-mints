class ApplicationController < Mints::BaseController
    include DefaultControllerVariables

    # Share cookies between domains
    include ShareCookies
    # Attach meta tags functions and initialize meta tags
    include Metadata

    # If California Content is enabled call out other managers
    include CaliforniaContentManager

    def manage_url_without_lang
        if @use_multi_language
            language = cookies[@language_cookie_name.to_sym] || @default_language
            redirect_to "/#{language}"
        end
    end
end
