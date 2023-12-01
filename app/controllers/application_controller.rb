class ApplicationController < ActionController::API
  def authorize_request
    header = request.headers['Authorization']
    header = header.split.last if header
    begin
      @decoded = JsonWebToken.decode(header)
      @current_user = User.find(@decoded[:user_id])
    rescue ActiveRecord::RecordNotFound => e
      render json: { errors: e.message }, status: :unauthorized
    rescue JWT::DecodeError => e
      render json: { errors: e.message }, status: :unauthorized
    end
  end
  # rubocop:enable Lint/DuplicateBranch

  def route_not_found
    render 'error_pages/404', status: :not_found
  end
end
