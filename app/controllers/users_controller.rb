class UsersController < ApplicationController
  rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity_response

  def create
    user = User.new(user_params)
    if user.save
      session[:user_id] = user.id
      render json: user, status: :created
    else
      render_unprocessable_entity_response(user.errors.full_messages)
    end
  end



  def show
    if session.include?(:user_id)
      user = User.find(session[:user_id])
      render json: user, status: :ok
    else
      render json: { error: "Not authorized" }, status: :unauthorized
    end
  end


  private

  def user_params
    params.permit(:username, :password, :password_confirmation, :image_url, :bio)
  end

  def render_unprocessable_entity_response(errors)
    render json: { errors: errors }, status: :unprocessable_entity
  end
end
