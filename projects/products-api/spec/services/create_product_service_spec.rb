require "rails_helper"

RSpec.describe CreateProductService, type: :service do
  describe "#call" do
    context "with valid parameters" do
      it "creates a product successfully" do
        params = {
          title: "Test Product",
          description: "A test product",
          quantity: 10,
          price: 99.99
        }

        result = CreateProductService.new(params).call

        expect(result).to be_a(Product)
        expect(result.title).to eq("Test Product")
        expect(result.description).to eq("A test product")
        expect(result.quantity).to eq(10)
        expect(result.price).to eq(99.99)
        expect(result.id).to be_present
      end

      it "creates a product without description" do
        params = {
          title: "Simple Product",
          quantity: 5,
          price: 49.99
        }

        result = CreateProductService.new(params).call

        expect(result).to be_a(Product)
        expect(result.title).to eq("Simple Product")
        expect(result.description).to be_nil
        expect(result.quantity).to eq(5)
        expect(result.price).to eq(49.99)
      end

      it "generates a unique UUID for each product" do
        params1 = { title: "Product 1", quantity: 5, price: 50.0 }
        params2 = { title: "Product 2", quantity: 10, price: 100.0 }

        product1 = CreateProductService.new(params1).call
        product2 = CreateProductService.new(params2).call

        expect(product1.id).not_to eq(product2.id)
      end

      it "persists product to database" do
        expect {
          CreateProductService.new({
            title: "DB Product",
            quantity: 20,
            price: 150.0
          }).call
        }.to change(Product, :count).by(1)
      end
    end

    context "with invalid title" do
      it "raises error when title is blank" do
        params = {
          quantity: 10,
          price: 99.99
        }

        expect {
          CreateProductService.new(params).call
        }.to raise_error(ArgumentError, /Title is required/)
      end

      it "raises error when title is empty string" do
        params = {
          title: "",
          quantity: 10,
          price: 99.99
        }

        expect {
          CreateProductService.new(params).call
        }.to raise_error(ArgumentError, /Title is required/)
      end

      it "raises error when title exceeds 100 characters" do
        params = {
          title: "a" * 101,
          quantity: 10,
          price: 99.99
        }

        expect {
          CreateProductService.new(params).call
        }.to raise_error(ArgumentError, /Title is required and must be between 1-100/)
      end

      it "allows title with exactly 100 characters" do
        params = {
          title: "a" * 100,
          quantity: 10,
          price: 99.99
        }

        result = CreateProductService.new(params).call

        expect(result).to be_a(Product)
        expect(result.title.length).to eq(100)
      end
    end

    context "with invalid quantity" do
      it "raises error when quantity is blank" do
        params = {
          title: "Test",
          price: 99.99
        }

        expect {
          CreateProductService.new(params).call
        }.to raise_error(ArgumentError, /Quantity is required/)
      end

      it "raises error when quantity is negative" do
        params = {
          title: "Test",
          quantity: -5,
          price: 99.99
        }

        expect {
          CreateProductService.new(params).call
        }.to raise_error(ArgumentError, /Quantity must be a non-negative/)
      end

      it "allows quantity of 0" do
        params = {
          title: "Test",
          quantity: 0,
          price: 99.99
        }

        result = CreateProductService.new(params).call

        expect(result).to be_a(Product)
        expect(result.quantity).to eq(0)
      end

      it "raises error when quantity is not an integer" do
        params = {
          title: "Test",
          quantity: "not_a_number",
          price: 99.99
        }

        expect {
          CreateProductService.new(params).call
        }.to raise_error(ArgumentError)
      end
    end

    context "with invalid price" do
      it "raises error when price is blank" do
        params = {
          title: "Test",
          quantity: 10
        }

        expect {
          CreateProductService.new(params).call
        }.to raise_error(ArgumentError, /Price is required/)
      end

      it "raises error when price is negative" do
        params = {
          title: "Test",
          quantity: 10,
          price: -50.0
        }

        expect {
          CreateProductService.new(params).call
        }.to raise_error(ArgumentError, /Price must be positive/)
      end

      it "raises error when price is zero" do
        params = {
          title: "Test",
          quantity: 10,
          price: 0
        }

        expect {
          CreateProductService.new(params).call
        }.to raise_error(ArgumentError, /Price must be positive/)
      end

      it "raises error when price is not a number" do
        params = {
          title: "Test",
          quantity: 10,
          price: "not_a_number"
        }

        expect {
          CreateProductService.new(params).call
        }.to raise_error(ArgumentError)
      end

      it "allows decimal prices" do
        params = {
          title: "Test",
          quantity: 10,
          price: 99.99
        }

        result = CreateProductService.new(params).call

        expect(result.price).to eq(99.99)
      end
    end

    context "with invalid description" do
      it "raises error when description exceeds 500 characters" do
        params = {
          title: "Test",
          description: "a" * 501,
          quantity: 10,
          price: 99.99
        }

        expect {
          CreateProductService.new(params).call
        }.to raise_error(ArgumentError, /Description must not exceed/)
      end

      it "allows description with exactly 500 characters" do
        params = {
          title: "Test",
          description: "a" * 500,
          quantity: 10,
          price: 99.99
        }

        result = CreateProductService.new(params).call

        expect(result.description.length).to eq(500)
      end

      it "allows blank description" do
        params = {
          title: "Test",
          description: "",
          quantity: 10,
          price: 99.99
        }

        result = CreateProductService.new(params).call

        expect(result.description).to be_empty
      end

      it "allows nil description" do
        params = {
          title: "Test",
          quantity: 10,
          price: 99.99
        }

        result = CreateProductService.new(params).call

        expect(result.description).to be_nil
      end
    end
  end
end
