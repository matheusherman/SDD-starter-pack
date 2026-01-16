require "rails_helper"

RSpec.describe Product, type: :model do
  describe "validations" do
    it "validates presence of title" do
      product = Product.new(quantity: 10, price: 99.99)
      expect(product).not_to be_valid
      expect(product.errors[:title]).to be_present
    end

    it "validates title length between 1 and 100" do
      product = Product.new(title: "", quantity: 10, price: 99.99)
      expect(product).not_to be_valid

      product = Product.new(title: "a" * 101, quantity: 10, price: 99.99)
      expect(product).not_to be_valid
    end

    it "validates presence of quantity" do
      product = Product.new(title: "Test", price: 99.99, quantity: nil)
      expect(product).not_to be_valid
      expect(product.errors[:quantity]).to be_present
    end

    it "validates quantity is non-negative" do
      product = Product.new(title: "Test", quantity: -1, price: 99.99)
      expect(product).not_to be_valid
    end

    it "validates presence of price" do
      product = Product.new(title: "Test", quantity: 10)
      expect(product).not_to be_valid
      expect(product.errors[:price]).to be_present
    end

    it "validates price is positive" do
      product = Product.new(title: "Test", quantity: 10, price: -50.0)
      expect(product).not_to be_valid

      product = Product.new(title: "Test", quantity: 10, price: 0)
      expect(product).not_to be_valid
    end

    it "validates description length max 500" do
      product = Product.new(title: "Test", quantity: 10, price: 99.99, description: "a" * 501)
      expect(product).not_to be_valid
    end

    it "creates valid product with all fields" do
      product = Product.new(
        title: "Valid Product",
        description: "A valid product",
        quantity: 10,
        price: 99.99
      )
      expect(product).to be_valid
    end
  end

  describe "callbacks" do
    it "generates UUID on creation" do
      product = Product.create(
        title: "Test",
        quantity: 10,
        price: 99.99
      )

      expect(product.id).to be_present
      expect(product.id).to match(/^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/)
    end

    it "generates unique IDs" do
      product1 = Product.create(title: "Product 1", quantity: 5, price: 50.0)
      product2 = Product.create(title: "Product 2", quantity: 10, price: 100.0)

      expect(product1.id).not_to eq(product2.id)
    end
  end
end
