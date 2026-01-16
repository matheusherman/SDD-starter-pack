class LoginService
  def initialize(params)
    @params = params
  end

  def call
    validate_input!
    authenticate_user
  end

  private

  def validate_input!
    raise ArgumentError, "Email is required and must be a valid email format" if invalid_email?
    raise ArgumentError, "Password is required" if invalid_password?
  end

  def invalid_email?
    email = @params[:email].to_s.strip
    email.blank? || !email.match?(URI::MailTo::EMAIL_REGEXP)
  end

  def invalid_password?
    @params[:password].to_s.blank?
  end

  def authenticate_user
    email = @params[:email].to_s.downcase.strip
    password = @params[:password].to_s

    user = User.find_by(email: email)
    raise ArgumentError, "Invalid email or password" if user.nil? || !user.authenticate(password)

    token = JwtToken.generate(user_id: user.id, role: user.role)
    user.token = token
    user
  end
end
