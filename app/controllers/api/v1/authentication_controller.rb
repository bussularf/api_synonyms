module API
  module V1
    class AuthenticationController < ApplicationController
      def login
        @user = User.find_by(name: params[:name])
        if @user&.authenticate!(params[:name], params[:password])
          token = JsonWebToken.encode(user_id: @user.id)
          time = Time.zone.now + 24.hours.to_i
          render json: { token: token, exp: time.strftime('%m-%d-%Y %H:%M'),
                        name: @user.name }, status: :created
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