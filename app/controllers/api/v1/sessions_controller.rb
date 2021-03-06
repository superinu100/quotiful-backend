module Api
  module V1
    class SessionsController < Api::BaseController
      
      skip_before_filter :validate_authentication_token
      before_filter :ensure_params_user_exist, only: [:create]
     
      def create
        user = User.find_for_database_authentication(email: params[:user][:email])
        return invalid_login_attempt unless user
        return deactivated_user unless user.active?

        if user.valid_password?(params[:user][:password])
          user.using_this_device(params[:device_token])
          json = Response::Object.new('user', user, {current_user_id: user.id, api_version: @api_version}).to_json
          render json: json, status: 200
          return
        end

        invalid_login_attempt(user)
      end
      
      def destroy
        Device.signs_out_in(params[:device_token])
        render json: { success: true }, status: 200
      end
     
      protected
       
        def invalid_login_attempt(user)
          warden.custom_failure!
          code = user.has_password? ? 100 : 101
          render json: { success: false, signin_error: code  }, status: 200
        end

    end
  end
end