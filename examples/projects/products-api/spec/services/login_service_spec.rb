require "rails_helper"

RSpec.describe LoginService, type: :service do
  let(:user) do
    User.create(
      email: "login@example.com",
      name: "Login Test",
      password: "SecurePassword123",
      password_confirmation: "SecurePassword123",
      role: "user"
    )
  end

  describe "#call" do
    context "with valid parameters" do
      it "authenticates user successfully" do
        user  # Force creation
        
        params = {
          email: "login@example.com",
          password: "SecurePassword123"
        }

        result = LoginService.new(params).call

        expect(result).to be_a(User)
        expect(result.id).to eq(user.id)
        expect(result.email).to eq(user.email)
        expect(result.token).to be_present
      end

      it "generates JWT token" do
        user  # Force creation
        
        params = {
          email: "login@example.com",
          password: "SecurePassword123"
        }

        result = LoginService.new(params).call

        expect(result.token).to be_present
        decoded = JwtToken.decode(result.token)
        expect(decoded["user_id"]).to eq(user.id)
        expect(decoded["role"]).to eq("user")
      end

      it "token contains user_id and role" do
        user  # Force creation
        
        params = {
          email: "login@example.com",
          password: "SecurePassword123"
        }

        result = LoginService.new(params).call
        decoded = JwtToken.decode(result.token)

        expect(decoded).to have_key("user_id")
        expect(decoded).to have_key("role")
      end

      it "email is case insensitive" do
        user  # Force creation
        
        params = {
          email: "LOGIN@EXAMPLE.COM",
          password: "SecurePassword123"
        }

        result = LoginService.new(params).call

        expect(result.id).to eq(user.id)
      end
    end

    context "with invalid email" do
      it "raises error when email is blank" do
        params = {
          password: "SecurePassword123"
        }

        expect {
          LoginService.new(params).call
        }.to raise_error(ArgumentError, /Email is required/)
      end

      it "raises error when email format is invalid" do
        params = {
          email: "invalid_email",
          password: "SecurePassword123"
        }

        expect {
          LoginService.new(params).call
        }.to raise_error(ArgumentError, /Email is required and must be a valid email format/)
      end
    end

    context "with invalid password" do
      it "raises error when password is blank" do
        params = {
          email: "login@example.com"
        }

        expect {
          LoginService.new(params).call
        }.to raise_error(ArgumentError, /Password is required/)
      end
    end

    context "with wrong credentials" do
      it "raises error when email does not exist" do
        params = {
          email: "nonexistent@example.com",
          password: "SecurePassword123"
        }

        expect {
          LoginService.new(params).call
        }.to raise_error(ArgumentError, /Invalid email or password/)
      end

      it "raises error when password is wrong" do
        params = {
          email: "login@example.com",
          password: "WrongPassword123"
        }

        expect {
          LoginService.new(params).call
        }.to raise_error(ArgumentError, /Invalid email or password/)
      end
    end
  end
end
