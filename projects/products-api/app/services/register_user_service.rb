class RegisterUserService
  def initialize(params)
    @params = params
  end

  def call
    validate_input!
    check_email_uniqueness!
    create_user
  end

  private

  def validate_input!
    raise ArgumentError, "Email is required and must be a valid email format" if invalid_email?
    raise ArgumentError, "Password must be at least 8 characters" if invalid_password?
    raise ArgumentError, "Name is required and must be between 1-100 characters" if invalid_name?
  end

  def invalid_email?
    email = @params[:email].to_s.strip
    email.blank? || !email.match?(URI::MailTo::EMAIL_REGEXP)
  end

  def invalid_password?
    password = @params[:password].to_s
    password.blank? || password.length < 8
  end

  def invalid_name?
    name = @params[:name].to_s
    name.blank? || name.length < 1 || name.length > 100
  end

  def check_email_uniqueness!
    email = @params[:email].to_s.downcase.strip
    raise ArgumentError, "Email already registered" if User.exists?(email: email)
  end

  def create_user
    user = User.new(
      email: @params[:email].to_s.downcase.strip,
      password: @params[:password],
      password_confirmation: @params[:password],
      name: @params[:name],
      role: "user"
    )

    raise ArgumentError, "Failed to create user" unless user.save

    token = JwtToken.generate(user_id: user.id, role: user.role)
    user.token = token
    user
  end
end
