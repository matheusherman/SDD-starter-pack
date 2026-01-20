class Api::AuthController < ApplicationController
  def login
    user = LoginService.new(login_params).call
    render json: { status: "success", data: UserSerializer.new(user).serialize }, status: :ok
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

  def forgot_password
    result = ForgotPasswordService.new(forgot_password_params[:email]).call

    if result[:success]
      render json: { status: "success", data: result[:data] }, status: :ok
    else
      render json: { status: "error", error: result[:error] }, status: :bad_request
    end
  end

  def reset_password
    result = ResetPasswordService.new(
      reset_password_params[:token],
      reset_password_params[:new_password]
    ).call

    if result[:success]
      render json: { status: "success", data: result[:data] }, status: :ok
    else
      render json: { status: "error", error: result[:error] }, status: :bad_request
    end
  end

  private

  def login_params
    params.permit(:email, :password)
  end

  def forgot_password_params
    params.permit(:email)
  end

  def reset_password_params
    params.permit(:token, :new_password)
  end
end
