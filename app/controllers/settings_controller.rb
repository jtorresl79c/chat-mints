class SettingsController < Mints::AdminBaseController
  before_action :signed, except: [:login]

  include DefaultControllerVariables
  include Metadata

  def index
  end

  def login
    redirect_to '/settings' if mints_user_signed_in?
  end

  def logout
    mints_user_logout
  end

  private

  def signed
    begin
      @me = @mints_user.me['data']
    rescue Mints::Errors::AccessDeniedException => e
      redirect_to '/settings/login'
    end
  end
end
