class Api::UsersController < ApplicationController
  def create
    user = RegisterUserService.new(user_params).call
    render json: { status: "success", data: UserSerializer.new(user).serialize }, status: :created
  rescue ArgumentError => e
    handle_argument_error(e)
  end

  private

  def user_params
    params.permit(:email, :password, :name)
  end
end
