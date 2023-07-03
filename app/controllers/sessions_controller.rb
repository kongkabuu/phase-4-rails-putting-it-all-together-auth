class SessionsController < ApplicationController
  rescue_from ActionController::InvalidAuthenticityToken, with: :render_unauthorized_response

  def create
    user = User.find_by(username: params[:username])

    if user&.authenticate(params[:password])
      session[:user_id] = user.id
      render json: user, status: :ok
    else
      render_unauthorized_response(["unathorized"])
    end
  end

  def destroy
    if session.include?(:user_id)
      session.delete(:user_id)
      head :no_content
    else
      render_unauthorized_response(['Unauthorized'])
    end
  end

  private

  def render_unauthorized_response(errors)
    render json: { errors: errors }, status: :unauthorized
  end
end
