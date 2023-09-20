module DefaultControllerVariables
  extend ActiveSupport::Concern

  included do
    before_action :set_core_variables
    before_action :set_locale
  end

  private

  def set_core_variables
    @use_multi_language = ENV.fetch('USE_MULTI_LANGUAGE', false).to_s.downcase.strip === 'true'
    @implementation_title = "Implementation Template"
    @controller = controller_name.downcase
    @controller_name_id = @controller.gsub('_', '-')
    @javascript_files = ['header_login']
    @google_tag_id = ENV['GOOGLE_TAG_ID']

  end

  def set_locale
    if @use_multi_language
      I18n.available_locales = ENV.fetch('CONTENT_VERSION_LOCALES', 'es').split(',')
      @default_language = 'es'
      @locale = I18n.available_locales.include?(params[:locale]&.to_sym) ? params[:locale] : @default_language
      @language_cookie_name = @implementation_title.downcase.gsub(' ', '_') + "_lang"
      I18n.locale = @locale

      update_lang_cookie
    end
  end

  def update_lang_cookie
    cookies[@language_cookie_name.to_sym] = @locale
  end
end