class Api::AuthController < ApplicationController
  def login
    user = LoginService.new(login_params).call
    render json: { status: "success", data: serialize_user(user) }, status: :ok
  rescue ArgumentError => e
    if e.message.include?("Invalid email or password")
      render json: {
        status: "error",
        error: {
          code: "UNAUTHORIZED",
          message: "Invalid email or password"
        }
      }, status: :unauthorized
    else
      handle_argument_error(e)
    end
  end

  private

  def login_params
    params.permit(:email, :password)
  end

  def serialize_user(user)
    {
      id: user.id,
      email: user.email,
      name: user.name,
      role: user.role,
      token: user.token
    }
  end
end
