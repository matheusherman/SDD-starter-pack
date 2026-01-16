class AuthMiddleware
  def initialize(app)
    @app = app
  end

  def call(env)
    token = extract_token(env)
    
    if token
      begin
        decoded = JwtToken.decode(token)
        env['user_id'] = decoded['user_id']
        env['user_role'] = decoded['role']
      rescue ArgumentError
        # Invalid token, will be handled by controller
      end
    end

    @app.call(env)
  end

  private

  def extract_token(env)
    auth_header = env['HTTP_AUTHORIZATION']
    return nil unless auth_header

    parts = auth_header.split(' ')
    parts[1] if parts.length == 2 && parts[0] == 'Bearer'
  end
end
