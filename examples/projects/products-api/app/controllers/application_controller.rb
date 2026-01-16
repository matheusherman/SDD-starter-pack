class ApplicationController < ActionController::API
  include AuthHelper
  
  rescue_from ArgumentError, with: :handle_argument_error
  rescue_from ActionController::ParameterMissing, with: :handle_parameter_missing
  rescue_from ActiveRecord::RecordNotFound, with: :handle_not_found

  protected

  def handle_argument_error(exception)
    message = exception.message

    # Determine error code based on message
    code = if message.include?("Email already registered")
             "EMAIL_ALREADY_EXISTS"
           elsif message.include?("Authentication required")
             "UNAUTHORIZED"
           elsif message.include?("Only admin")
             "FORBIDDEN"
           else
             "INVALID_INPUT"
           end

    status_code = case code
                  when "EMAIL_ALREADY_EXISTS"
                    :conflict
                  when "UNAUTHORIZED"
                    :unauthorized
                  when "FORBIDDEN"
                    :forbidden
                  else
                    :bad_request
                  end

    render json: {
      status: "error",
      error: {
        code: code,
        message: message
      }
    }, status: status_code
  end

  def handle_parameter_missing(exception)
    render json: {
      status: "error",
      error: {
        code: "INVALID_INPUT",
        message: "Missing required parameter: #{exception.param}"
      }
    }, status: :bad_request
  end

  def handle_not_found(exception)
    render json: {
      status: "error",
      error: {
        code: "NOT_FOUND",
        message: "Resource not found"
      }
    }, status: :not_found
  end
end
