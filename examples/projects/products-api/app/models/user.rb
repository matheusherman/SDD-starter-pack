class User < ApplicationRecord
  # Associations
  has_secure_password

  # Attributes
  attr_accessor :token

  # Constants
  VALID_EMAIL_REGEX = URI::MailTo::EMAIL_REGEXP
  VALID_ROLES = %w[user admin].freeze

  # Validations
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }, uniqueness: true
  validates :name, presence: true, length: { minimum: 1, maximum: 100 }
  validates :password, presence: true, length: { minimum: 8 }, if: -> { password.present? || password_confirmation.present? }
  validates :role, presence: true, inclusion: { in: VALID_ROLES }

  # Callbacks
  before_create :set_uuid
  before_save :downcase_email

  private

  def set_uuid
    self.id = SecureRandom.uuid if id.blank?
  end

  def downcase_email
    self.email = email.downcase
  end
end
