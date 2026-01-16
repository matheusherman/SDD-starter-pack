module JwtToken
  SECRET_KEY = ENV.fetch("JWT_SECRET_KEY", "your-secret-key-change-in-production")
  EXPIRATION_TIME = 24.hours

  def self.generate(user_id:, role:)
    payload = {
      user_id: user_id,
      role: role,
      exp: (Time.now + EXPIRATION_TIME).to_i,
      iat: Time.now.to_i
    }
    JWT.encode(payload, SECRET_KEY, "HS256")
  end

  def self.decode(token)
    decoded = JWT.decode(token, SECRET_KEY, true, { algorithm: "HS256" })
    decoded[0]
  rescue JWT::DecodeError, JWT::ExpiredSignature => e
    raise ArgumentError, "Invalid or expired token: #{e.message}"
  end

  def self.valid?(token)
    decode(token)
    true
  rescue ArgumentError
    false
  end
end
