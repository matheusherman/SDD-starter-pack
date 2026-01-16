require "rails_helper"

RSpec.describe "POST /api/users", type: :request do
  describe "successful registration" do
    it "registers user with email, password and name" do
      params = {
        email: "newuser@example.com",
        password: "SecurePassword123",
        name: "New User"
      }

      post "/api/users", params: params

      expect(response).to have_http_status(:created)
      expect(response.content_type).to match(a_string_including("application/json"))

      json_response = JSON.parse(response.body)
      expect(json_response["status"]).to eq("success")
      expect(json_response["data"]).to include(
        "email" => "newuser@example.com",
        "name" => "New User",
        "role" => "user"
      )
      expect(json_response["data"]).to have_key("id")
      expect(json_response["data"]).to have_key("token")
      expect(json_response["data"]).to have_key("createdAt")
    end

    it "password is hashed before storage" do
      params = {
        email: "hashtest@example.com",
        password: "SecurePassword123",
        name: "Hash Test"
      }

      post "/api/users", params: params

      user = User.find_by(email: "hashtest@example.com")
      expect(user.password_digest).not_to eq("SecurePassword123")
      expect(user.authenticate("SecurePassword123")).to eq(user)
    end

    it "JWT token is generated and returned" do
      params = {
        email: "tokentest@example.com",
        password: "SecurePassword123",
        name: "Token Test"
      }

      post "/api/users", params: params

      json_response = JSON.parse(response.body)
      token = json_response["data"]["token"]

      expect(token).to be_present
      expect(token).to be_a(String)
      decoded = JwtToken.decode(token)
      expect(decoded["user_id"]).to be_present
      expect(decoded["role"]).to eq("user")
    end

    it "user role defaults to user" do
      params = {
        email: "roletest@example.com",
        password: "SecurePassword123",
        name: "Role Test"
      }

      post "/api/users", params: params

      json_response = JSON.parse(response.body)
      expect(json_response["data"]["role"]).to eq("user")
    end

    it "email is downcased" do
      params = {
        email: "TestUser@EXAMPLE.COM",
        password: "SecurePassword123",
        name: "Case Test"
      }

      post "/api/users", params: params

      user = User.find_by(email: "testuser@example.com")
      expect(user).to be_present
    end

    it "generates unique IDs for each user" do
      post "/api/users", params: { email: "user1@example.com", password: "Password123", name: "User 1" }
      id1 = JSON.parse(response.body)["data"]["id"]

      post "/api/users", params: { email: "user2@example.com", password: "Password123", name: "User 2" }
      id2 = JSON.parse(response.body)["data"]["id"]

      expect(id1).not_to eq(id2)
    end
  end

  describe "validation errors" do
    it "returns 400 when email is missing" do
      params = {
        password: "SecurePassword123",
        name: "Test User"
      }

      post "/api/users", params: params

      expect(response).to have_http_status(:bad_request)
      json_response = JSON.parse(response.body)
      expect(json_response["error"]["code"]).to eq("INVALID_INPUT")
      expect(json_response["error"]["message"]).to include("Email")
    end

    it "returns 400 when email format is invalid" do
      params = {
        email: "invalid_email",
        password: "SecurePassword123",
        name: "Test User"
      }

      post "/api/users", params: params

      expect(response).to have_http_status(:bad_request)
      json_response = JSON.parse(response.body)
      expect(json_response["error"]["code"]).to eq("INVALID_INPUT")
      expect(json_response["error"]["message"]).to include("Email")
    end

    it "returns 400 when password is missing" do
      params = {
        email: "test@example.com",
        name: "Test User"
      }

      post "/api/users", params: params

      expect(response).to have_http_status(:bad_request)
      json_response = JSON.parse(response.body)
      expect(json_response["error"]["code"]).to eq("INVALID_INPUT")
      expect(json_response["error"]["message"]).to include("Password")
    end

    it "returns 400 when password is less than 8 characters" do
      params = {
        email: "test@example.com",
        password: "short",
        name: "Test User"
      }

      post "/api/users", params: params

      expect(response).to have_http_status(:bad_request)
      json_response = JSON.parse(response.body)
      expect(json_response["error"]["code"]).to eq("INVALID_INPUT")
      expect(json_response["error"]["message"]).to include("8 characters")
    end

    it "returns 400 when name is missing" do
      params = {
        email: "test@example.com",
        password: "SecurePassword123"
      }

      post "/api/users", params: params

      expect(response).to have_http_status(:bad_request)
      json_response = JSON.parse(response.body)
      expect(json_response["error"]["code"]).to eq("INVALID_INPUT")
      expect(json_response["error"]["message"]).to include("Name")
    end

    it "returns 400 when name exceeds 100 characters" do
      params = {
        email: "test@example.com",
        password: "SecurePassword123",
        name: "a" * 101
      }

      post "/api/users", params: params

      expect(response).to have_http_status(:bad_request)
      json_response = JSON.parse(response.body)
      expect(json_response["error"]["code"]).to eq("INVALID_INPUT")
      expect(json_response["error"]["message"]).to include("Name")
    end

    it "returns 409 when email already exists" do
      create(:user, email: "existing@example.com")

      params = {
        email: "existing@example.com",
        password: "SecurePassword123",
        name: "Duplicate User"
      }

      post "/api/users", params: params

      expect(response).to have_http_status(:conflict)
      json_response = JSON.parse(response.body)
      expect(json_response["status"]).to eq("error")
      expect(json_response["error"]["code"]).to eq("EMAIL_ALREADY_EXISTS")
      expect(json_response["error"]["message"]).to include("Email already registered")
    end
  end

  describe "data persistence" do
    it "stores user in database" do
      expect {
        post "/api/users", params: {
          email: "persist@example.com",
          password: "SecurePassword123",
          name: "Persist Test"
        }
      }.to change(User, :count).by(1)

      user = User.last
      expect(user.email).to eq("persist@example.com")
      expect(user.name).to eq("Persist Test")
    end
  end
end
