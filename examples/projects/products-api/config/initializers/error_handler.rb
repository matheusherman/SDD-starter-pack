Rails.application.config.to_prepare do
  # Standard error handler
  ActionController::Base.rescue_from StandardError do |exception|
    case exception
    when ActiveRecord::RecordNotFound
      render json: {
        status: "error",
        error: {
          code: "NOT_FOUND",
          message: "Resource not found"
        }
      }, status: :not_found
    when ArgumentError
      render json: {
        status: "error",
        error: {
          code: "INVALID_INPUT",
          message: exception.message
        }
      }, status: :bad_request
    else
      render json: {
        status: "error",
        error: {
          code: "INTERNAL_ERROR",
          message: "An unexpected error occurred"
        }
      }, status: :internal_server_error
    end
  end
end
