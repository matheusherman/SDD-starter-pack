module AuthHelper
  def current_user
    return @current_user if defined?(@current_user)
    
    token = extract_token_from_request
    return nil unless token

    begin
      decoded = JwtToken.decode(token)
      @current_user = User.find(decoded['user_id'])
    rescue StandardError
      @current_user = nil
    end
  end

  def authenticate_user!
    raise ArgumentError, "Authentication required" if current_user.nil?
  end

  def authorize_admin!
    authenticate_user!
    raise ArgumentError, "Only admin can perform this action" unless current_user.role == "admin"
  end

  private

  def extract_token_from_request
    auth_header = request.headers['Authorization']
    return nil unless auth_header

    parts = auth_header.split(' ')
    parts[1] if parts.length == 2 && parts[0] == 'Bearer'
  end
end
