module Api
  module V1
    module Settings
        # base settings
        class BaseController < Api::ApiController
          before_action :verify_user

          def verify_user
            begin
              @me = @mints_user.me['data']
            rescue Mints::Errors::AccessDeniedException => e
              render json: { data: 'Not authorized' }, status: 401 if @me.nil?
            end
          end

        end
    end
  end
end
