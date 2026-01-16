require "rails_helper"

RSpec.describe RegisterUserService, type: :service do
  describe "#call" do
    context "with valid parameters" do
      it "registers user successfully" do
        params = {
          email: "newuser@example.com",
          password: "SecurePassword123",
          name: "New User"
        }

        user = RegisterUserService.new(params).call

        expect(user).to be_a(User)
        expect(user.email).to eq("newuser@example.com")
        expect(user.name).to eq("New User")
        expect(user.role).to eq("user")
        expect(user.id).to be_present
        expect(user.token).to be_present
      end

      it "password is hashed" do
        params = {
          email: "hash@example.com",
          password: "SecurePassword123",
          name: "Hash Test"
        }

        user = RegisterUserService.new(params).call

        expect(user.password_digest).not_to eq("SecurePassword123")
        expect(user.authenticate("SecurePassword123")).to eq(user)
      end

      it "generates JWT token" do
        params = {
          email: "token@example.com",
          password: "SecurePassword123",
          name: "Token Test"
        }

        user = RegisterUserService.new(params).call

        expect(user.token).to be_present
        decoded = JwtToken.decode(user.token)
        expect(decoded["user_id"]).to eq(user.id)
        expect(decoded["role"]).to eq("user")
      end

      it "role defaults to user" do
        params = {
          email: "role@example.com",
          password: "SecurePassword123",
          name: "Role Test"
        }

        user = RegisterUserService.new(params).call

        expect(user.role).to eq("user")
      end

      it "email is downcased" do
        params = {
          email: "UPPERCASE@EXAMPLE.COM",
          password: "SecurePassword123",
          name: "Case Test"
        }

        user = RegisterUserService.new(params).call

        expect(user.email).to eq("uppercase@example.com")
      end

      it "persists user to database" do
        expect {
          RegisterUserService.new({
            email: "persist@example.com",
            password: "SecurePassword123",
            name: "Persist Test"
          }).call
        }.to change(User, :count).by(1)
      end
    end

    context "with invalid email" do
      it "raises error when email is blank" do
        params = {
          password: "SecurePassword123",
          name: "Test"
        }

        expect {
          RegisterUserService.new(params).call
        }.to raise_error(ArgumentError, /Email is required/)
      end

      it "raises error when email is invalid format" do
        params = {
          email: "invalid_email",
          password: "SecurePassword123",
          name: "Test"
        }

        expect {
          RegisterUserService.new(params).call
        }.to raise_error(ArgumentError, /Email is required and must be a valid email format/)
      end

      it "raises error when email already exists" do
        create(:user, email: "existing@example.com")

        params = {
          email: "existing@example.com",
          password: "SecurePassword123",
          name: "Test"
        }

        expect {
          RegisterUserService.new(params).call
        }.to raise_error(ArgumentError, /Email already registered/)
      end

      it "checks email uniqueness case insensitively" do
        create(:user, email: "test@example.com")

        params = {
          email: "TEST@EXAMPLE.COM",
          password: "SecurePassword123",
          name: "Test"
        }

        expect {
          RegisterUserService.new(params).call
        }.to raise_error(ArgumentError, /Email already registered/)
      end
    end

    context "with invalid password" do
      it "raises error when password is blank" do
        params = {
          email: "test@example.com",
          name: "Test"
        }

        expect {
          RegisterUserService.new(params).call
        }.to raise_error(ArgumentError, /Password must be at least 8 characters/)
      end

      it "raises error when password is less than 8 characters" do
        params = {
          email: "test@example.com",
          password: "short",
          name: "Test"
        }

        expect {
          RegisterUserService.new(params).call
        }.to raise_error(ArgumentError, /Password must be at least 8 characters/)
      end

      it "allows password with exactly 8 characters" do
        params = {
          email: "test@example.com",
          password: "12345678",
          name: "Test"
        }

        user = RegisterUserService.new(params).call

        expect(user).to be_a(User)
        expect(user.authenticate("12345678")).to eq(user)
      end
    end

    context "with invalid name" do
      it "raises error when name is blank" do
        params = {
          email: "test@example.com",
          password: "SecurePassword123"
        }

        expect {
          RegisterUserService.new(params).call
        }.to raise_error(ArgumentError, /Name is required/)
      end

      it "raises error when name exceeds 100 characters" do
        params = {
          email: "test@example.com",
          password: "SecurePassword123",
          name: "a" * 101
        }

        expect {
          RegisterUserService.new(params).call
        }.to raise_error(ArgumentError, /Name is required and must be between 1-100/)
      end

      it "allows name with exactly 100 characters" do
        params = {
          email: "test@example.com",
          password: "SecurePassword123",
          name: "a" * 100
        }

        user = RegisterUserService.new(params).call

        expect(user.name.length).to eq(100)
      end
    end
  end
end
