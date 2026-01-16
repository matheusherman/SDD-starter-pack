require "rails_helper"

RSpec.describe User, type: :model do
  describe "validations" do
    it "validates presence of email" do
      user = User.new(name: "Test", password: "password123", password_confirmation: "password123")
      expect(user).not_to be_valid
      expect(user.errors[:email]).to be_present
    end

    it "validates email format" do
      user = User.new(email: "invalid_email", name: "Test", password: "password123", password_confirmation: "password123")
      expect(user).not_to be_valid
      expect(user.errors[:email]).to be_present
    end

    it "validates email uniqueness" do
      create(:user, email: "test@example.com")
      user = User.new(email: "test@example.com", name: "Test", password: "password123", password_confirmation: "password123")
      expect(user).not_to be_valid
      expect(user.errors[:email]).to be_present
    end

    it "validates presence of password" do
      user = User.new(email: "test@example.com", name: "Test")
      expect(user).not_to be_valid
      expect(user.errors[:password]).to be_present
    end

    it "validates password minimum length" do
      user = User.new(email: "test@example.com", name: "Test", password: "short", password_confirmation: "short")
      expect(user).not_to be_valid
      expect(user.errors[:password]).to be_present
    end

    it "validates presence of name" do
      user = User.new(email: "test@example.com", password: "password123", password_confirmation: "password123")
      expect(user).not_to be_valid
      expect(user.errors[:name]).to be_present
    end

    it "validates name length between 1 and 100" do
      user = User.new(email: "test@example.com", password: "password123", password_confirmation: "password123", name: "a" * 101)
      expect(user).not_to be_valid
      expect(user.errors[:name]).to be_present
    end

    it "validates role is included in valid roles" do
      user = User.new(email: "test@example.com", password: "password123", password_confirmation: "password123", name: "Test", role: "invalid")
      expect(user).not_to be_valid
      expect(user.errors[:role]).to be_present
    end

    it "creates valid user with all fields" do
      user = User.new(
        email: "valid@example.com",
        password: "password123",
        password_confirmation: "password123",
        name: "Valid User",
        role: "user"
      )
      expect(user).to be_valid
    end
  end

  describe "callbacks" do
    it "generates UUID on creation" do
      user = create(:user)
      expect(user.id).to be_present
      expect(user.id).to match(/^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/)
    end

    it "downcases email on save" do
      user = create(:user, email: "TEST@EXAMPLE.COM")
      expect(user.email).to eq("test@example.com")
    end
  end

  describe "associations" do
    it "has secure password" do
      user = build(:user, password: "password123", password_confirmation: "password123")
      expect(user).to respond_to(:password_digest)
    end
  end

  describe "password hashing" do
    it "hashes password before storage" do
      user = create(:user)
      expect(user.password_digest).not_to eq(user.password)
    end

    it "authenticates with correct password" do
      user = User.new(
        email: "auth@example.com",
        name: "Auth Test",
        password: "SpecialPass123",
        password_confirmation: "SpecialPass123"
      )
      user.save

      authenticated = user.authenticate("SpecialPass123")
      expect(authenticated).to eq(user)
    end

    it "fails to authenticate with wrong password" do
      user = create(:user)
      expect(user.authenticate("wrongpassword")).to be_falsy
    end
  end
end
