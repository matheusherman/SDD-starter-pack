require "rails_helper"

RSpec.describe "POST /api/auth/login", type: :request do
  let(:user) do
    User.create(
      email: "login@example.com",
      name: "Login Test",
      password: "SecurePassword123",
      password_confirmation: "SecurePassword123",
      role: "user"
    )
  end

  describe "successful login" do
    it "logs in with valid email and password" do
      user  # Force creation of the user
      
      params = {
        email: "login@example.com",
        password: "SecurePassword123"
      }

      post "/api/auth/login", params: params

      expect(response).to have_http_status(:ok)
      expect(response.content_type).to match(a_string_including("application/json"))

      json_response = JSON.parse(response.body)
      expect(json_response["status"]).to eq("success")
      expect(json_response["data"]).to include(
        "email" => "login@example.com",
        "role" => "user"
      )
      expect(json_response["data"]).to have_key("id")
      expect(json_response["data"]).to have_key("token")
      expect(json_response["data"]).to have_key("name")
    end

    it "JWT token is generated and returned" do
      user  # Force creation of the user
      
      params = {
        email: "login@example.com",
        password: "SecurePassword123"
      }

      post "/api/auth/login", params: params

      json_response = JSON.parse(response.body)
      token = json_response["data"]["token"]

      expect(token).to be_present
      decoded = JwtToken.decode(token)
      expect(decoded["user_id"]).to eq(user.id)
      expect(decoded["role"]).to eq("user")
    end

    it "token contains user_id and role" do
      user  # Force creation of the user
      
      params = {
        email: "login@example.com",
        password: "SecurePassword123"
      }

      post "/api/auth/login", params: params

      json_response = JSON.parse(response.body)
      token = json_response["data"]["token"]
      decoded = JwtToken.decode(token)

      expect(decoded).to have_key("user_id")
      expect(decoded).to have_key("role")
      expect(decoded["user_id"]).to eq(user.id)
      expect(decoded["role"]).to eq("user")
    end

    it "user data is returned with login" do
      user  # Force creation of the user
      
      params = {
        email: "login@example.com",
        password: "SecurePassword123"
      }

      post "/api/auth/login", params: params

      json_response = JSON.parse(response.body)
      expect(json_response["data"]["id"]).to eq(user.id)
      expect(json_response["data"]["email"]).to eq(user.email)
      expect(json_response["data"]["name"]).to eq(user.name)
      expect(json_response["data"]["role"]).to eq(user.role)
    end

    it "email is case insensitive" do
      user  # Force creation of the user
      
      params = {
        email: "LOGIN@EXAMPLE.COM",
        password: "SecurePassword123"
      }

      post "/api/auth/login", params: params

      expect(response).to have_http_status(:ok)
      json_response = JSON.parse(response.body)
      expect(json_response["status"]).to eq("success")
    end
  end

  describe "validation errors" do
    it "returns 400 when email is missing" do
      params = {
        password: "SecurePassword123"
      }

      post "/api/auth/login", params: params

      expect(response).to have_http_status(:bad_request)
      json_response = JSON.parse(response.body)
      expect(json_response["error"]["code"]).to eq("INVALID_INPUT")
      expect(json_response["error"]["message"]).to include("Email")
    end

    it "returns 400 when email format is invalid" do
      params = {
        email: "invalid_email",
        password: "SecurePassword123"
      }

      post "/api/auth/login", params: params

      expect(response).to have_http_status(:bad_request)
      json_response = JSON.parse(response.body)
      expect(json_response["error"]["code"]).to eq("INVALID_INPUT")
      expect(json_response["error"]["message"]).to include("Email")
    end

    it "returns 400 when password is missing" do
      params = {
        email: "login@example.com"
      }

      post "/api/auth/login", params: params

      expect(response).to have_http_status(:bad_request)
      json_response = JSON.parse(response.body)
      expect(json_response["error"]["code"]).to eq("INVALID_INPUT")
      expect(json_response["error"]["message"]).to include("Password")
    end

    it "returns 401 when email does not exist" do
      params = {
        email: "nonexistent@example.com",
        password: "SecurePassword123"
      }

      post "/api/auth/login", params: params

      expect(response).to have_http_status(:unauthorized)
      json_response = JSON.parse(response.body)
      expect(json_response["error"]["code"]).to eq("UNAUTHORIZED")
      expect(json_response["error"]["message"]).to eq("Invalid email or password")
    end

    it "returns 401 when password is wrong" do
      params = {
        email: "login@example.com",
        password: "WrongPassword123"
      }

      post "/api/auth/login", params: params

      expect(response).to have_http_status(:unauthorized)
      json_response = JSON.parse(response.body)
      expect(json_response["error"]["code"]).to eq("UNAUTHORIZED")
      expect(json_response["error"]["message"]).to eq("Invalid email or password")
    end

    it "returns 401 when email not registered" do
      params = {
        email: "notregistered@example.com",
        password: "AnyPassword123"
      }

      post "/api/auth/login", params: params

      expect(response).to have_http_status(:unauthorized)
      json_response = JSON.parse(response.body)
      expect(json_response["error"]["code"]).to eq("UNAUTHORIZED")
    end
  end
end

RSpec.describe "POST /api/auth/forgot_password", type: :request do
  let(:user) do
    User.create(
      email: "forgot@example.com",
      name: "Forgot Test",
      password: "SecurePassword123",
      password_confirmation: "SecurePassword123",
      role: "user"
    )
  end

  describe "successful forgot password request" do
    it "generates reset token for valid email" do
      user  # Force creation

      params = { email: "forgot@example.com" }
      post "/api/auth/forgot_password", params: params

      expect(response).to have_http_status(:ok)
      json_response = JSON.parse(response.body)
      expect(json_response["status"]).to eq("success")
      expect(json_response["data"]).to have_key("reset_token")
      expect(json_response["data"]).to have_key("token_expires_at")
      expect(json_response["data"]["message"]).to include("Reset link sent")
    end

    it "saves reset token to database" do
      user  # Force creation

      params = { email: "forgot@example.com" }
      post "/api/auth/forgot_password", params: params

      json_response = JSON.parse(response.body)
      reset_token = json_response["data"]["reset_token"]

      user.reload
      expect(user.reset_token).to eq(reset_token)
      expect(user.reset_token_expires_at).to be_present
    end

    it "reset token expires in 1 hour" do
      user  # Force creation
      time_before = Time.current

      params = { email: "forgot@example.com" }
      post "/api/auth/forgot_password", params: params

      time_after = Time.current
      user.reload

      # Token should expire approximately 1 hour from now
      expect(user.reset_token_expires_at).to be > time_before + 59.minutes
      expect(user.reset_token_expires_at).to be < time_after + 61.minutes
    end
  end

  describe "error cases" do
    it "returns 400 INVALID_EMAIL for non-existent email" do
      params = { email: "nonexistent@example.com" }
      post "/api/auth/forgot_password", params: params

      expect(response).to have_http_status(:bad_request)
      json_response = JSON.parse(response.body)
      expect(json_response["error"]["code"]).to eq("INVALID_EMAIL")
      expect(json_response["error"]["message"]).to include("Email não encontrado")
    end
  end
end

RSpec.describe "POST /api/auth/reset_password", type: :request do
  let(:user) do
    User.create(
      email: "reset@example.com",
      name: "Reset Test",
      password: "OldPassword123",
      password_confirmation: "OldPassword123",
      role: "user"
    )
  end

  let(:valid_reset_token) do
    user  # Force creation
    params = { email: "reset@example.com" }
    post "/api/auth/forgot_password", params: params
    json_response = JSON.parse(response.body)
    json_response["data"]["reset_token"]
  end

  describe "successful password reset" do
    it "resets password with valid token and new password" do
      token = valid_reset_token

      params = {
        token: token,
        new_password: "NewPassword123"
      }
      post "/api/auth/reset_password", params: params

      expect(response).to have_http_status(:ok)
      json_response = JSON.parse(response.body)
      expect(json_response["status"]).to eq("success")
      expect(json_response["data"]["message"]).to include("successfully reset")
    end

    it "clears reset token after successful reset" do
      token = valid_reset_token

      params = {
        token: token,
        new_password: "NewPassword123"
      }
      post "/api/auth/reset_password", params: params

      user.reload
      expect(user.reset_token).to be_nil
      expect(user.reset_token_expires_at).to be_nil
    end

    it "allows login with new password" do
      token = valid_reset_token

      params = {
        token: token,
        new_password: "NewPassword123"
      }
      post "/api/auth/reset_password", params: params

      # Try to login with new password
      login_params = {
        email: "reset@example.com",
        password: "NewPassword123"
      }
      post "/api/auth/login", params: login_params

      expect(response).to have_http_status(:ok)
      json_response = JSON.parse(response.body)
      expect(json_response["status"]).to eq("success")
    end

    it "prevents login with old password" do
      token = valid_reset_token

      params = {
        token: token,
        new_password: "NewPassword123"
      }
      post "/api/auth/reset_password", params: params

      # Try to login with old password
      login_params = {
        email: "reset@example.com",
        password: "OldPassword123"
      }
      post "/api/auth/login", params: login_params

      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe "error cases" do
    it "returns 400 INVALID_PASSWORD for password < 8 characters" do
      token = valid_reset_token

      params = {
        token: token,
        new_password: "Short1"
      }
      post "/api/auth/reset_password", params: params

      expect(response).to have_http_status(:bad_request)
      json_response = JSON.parse(response.body)
      expect(json_response["error"]["code"]).to eq("INVALID_PASSWORD")
      expect(json_response["error"]["message"]).to include("mínimo 8 caracteres")
    end

    it "returns 400 INVALID_TOKEN for non-existent token" do
      params = {
        token: "invalid_token_xyz",
        new_password: "NewPassword123"
      }
      post "/api/auth/reset_password", params: params

      expect(response).to have_http_status(:bad_request)
      json_response = JSON.parse(response.body)
      expect(json_response["error"]["code"]).to eq("INVALID_TOKEN")
    end

    it "returns 400 EXPIRED_TOKEN for expired token" do
      token = valid_reset_token
      user.reload

      # Manually expire the token
      user.update(reset_token_expires_at: Time.current - 1.hour)

      params = {
        token: token,
        new_password: "NewPassword123"
      }
      post "/api/auth/reset_password", params: params

      expect(response).to have_http_status(:bad_request)
      json_response = JSON.parse(response.body)
      expect(json_response["error"]["code"]).to eq("EXPIRED_TOKEN")
      expect(json_response["error"]["message"]).to include("expirou")
    end

    it "prevents reusing the same token" do
      token = valid_reset_token

      # First reset - should succeed
      params = {
        token: token,
        new_password: "NewPassword123"
      }
      post "/api/auth/reset_password", params: params
      expect(response).to have_http_status(:ok)

      # Second reset with same token - should fail
      params = {
        token: token,
        new_password: "AnotherPassword123"
      }
      post "/api/auth/reset_password", params: params

      expect(response).to have_http_status(:bad_request)
      json_response = JSON.parse(response.body)
      expect(json_response["error"]["code"]).to eq("INVALID_TOKEN")
    end
  end
end

