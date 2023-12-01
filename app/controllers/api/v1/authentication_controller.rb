require 'debug'

require Rails.root.join('lib', 'json_web_token')

module Api
  module V1
    class AuthenticationController < ApplicationController
      def login
        @user = User.find_by(username: params[:username])
        binding.b
        if @user&.custom_authenticate(params[:username], params[:password])
          token = JsonWebToken.encode(user_id: @user.id)
          time = Time.zone.now + 24.hours.to_i
          render json: { token: token, expires: time.strftime('%m-%d-%Y %H:%M'),
                        username: @user.username }, status: :created
        else
          render json: { error: 'unauthorized' }, status: :unauthorized
        end
      end

      private

      def login_params
        params.permit(:email, :password)
      end
    end
  end
end