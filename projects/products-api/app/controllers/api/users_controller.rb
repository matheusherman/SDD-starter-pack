class Api::UsersController < ApplicationController
  def create
    user = RegisterUserService.new(user_params).call
    render json: { status: "success", data: serialize_user(user) }, status: :created
  rescue ArgumentError => e
    handle_argument_error(e)
  end

  private

  def user_params
    params.permit(:email, :password, :name)
  end

  def serialize_user(user)
    {
      id: user.id,
      email: user.email,
      name: user.name,
      role: user.role,
      createdAt: user.created_at.iso8601,
      token: user.token
    }
  end
end
