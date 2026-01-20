class Product < ApplicationRecord
  # Associations
  has_many :cart_items, foreign_key: :product_id, primary_key: :id, dependent: :destroy
  has_many :carts, through: :cart_items
  has_many :order_items, foreign_key: :product_id, primary_key: :id, dependent: :destroy
  has_many :orders, through: :order_items

  # Validations
  validates :title, presence: true, length: { minimum: 1, maximum: 100 }
  validates :description, length: { maximum: 500 }, allow_blank: true
  validates :quantity, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :price, presence: true, numericality: { greater_than: 0 }

  # Callbacks
  before_create :set_uuid

  private

  def set_uuid
    self.id = SecureRandom.uuid if id.blank?
  end
end
