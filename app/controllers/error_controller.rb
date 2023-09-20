class ErrorController < ActionController::Base
  include DefaultControllerVariables
  around_action :switch_locale

  def not_found; end

  def switch_locale(&action)
    I18n.with_locale(@locale, &action)
  end
end