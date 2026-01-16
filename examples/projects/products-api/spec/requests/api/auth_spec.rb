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
