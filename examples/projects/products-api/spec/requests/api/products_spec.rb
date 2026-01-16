require "rails_helper"

RSpec.describe "POST /api/products", type: :request do
  describe "successful creation" do
    it "creates a product with title, quantity and price" do
      params = {
        title: "Test Product",
        quantity: 10,
        price: 99.99
      }

      post "/api/products", params: params

      expect(response).to have_http_status(:created)
      expect(response.content_type).to match(a_string_including("application/json"))

      json_response = JSON.parse(response.body)
      expect(json_response["status"]).to eq("success")
      expect(json_response["data"]).to include(
        "title" => "Test Product",
        "quantity" => 10,
        "price" => 99.99,
        "description" => nil
      )
      expect(json_response["data"]).to have_key("id")
      expect(json_response["data"]).to have_key("createdAt")
    end

    it "creates a product with title, description, quantity and price" do
      params = {
        title: "Premium Product",
        description: "This is a premium product with excellent quality",
        quantity: 50,
        price: 199.99
      }

      post "/api/products", params: params

      expect(response).to have_http_status(:created)

      json_response = JSON.parse(response.body)
      expect(json_response["status"]).to eq("success")
      expect(json_response["data"]).to include(
        "title" => "Premium Product",
        "description" => "This is a premium product with excellent quality",
        "quantity" => 50,
        "price" => 199.99
      )
    end

    it "generates unique IDs for each product" do
      post "/api/products", params: { title: "Product 1", quantity: 5, price: 50.0 }
      id1 = JSON.parse(response.body)["data"]["id"]

      post "/api/products", params: { title: "Product 2", quantity: 10, price: 100.0 }
      id2 = JSON.parse(response.body)["data"]["id"]

      expect(id1).not_to eq(id2)
    end
  end

  describe "validation errors" do
    it "returns 400 when title is missing" do
      params = {
        quantity: 10,
        price: 99.99
      }

      post "/api/products", params: params

      expect(response).to have_http_status(:bad_request)

      json_response = JSON.parse(response.body)
      expect(json_response["status"]).to eq("error")
      expect(json_response["error"]["code"]).to eq("INVALID_INPUT")
      expect(json_response["error"]["message"]).to include("Title")
    end

    it "returns 400 when quantity is missing" do
      params = {
        title: "Test Product",
        price: 99.99
      }

      post "/api/products", params: params

      expect(response).to have_http_status(:bad_request)

      json_response = JSON.parse(response.body)
      expect(json_response["status"]).to eq("error")
      expect(json_response["error"]["code"]).to eq("INVALID_INPUT")
      expect(json_response["error"]["message"]).to include("Quantity")
    end

    it "returns 400 when price is missing" do
      params = {
        title: "Test Product",
        quantity: 10
      }

      post "/api/products", params: params

      expect(response).to have_http_status(:bad_request)

      json_response = JSON.parse(response.body)
      expect(json_response["status"]).to eq("error")
      expect(json_response["error"]["code"]).to eq("INVALID_INPUT")
      expect(json_response["error"]["message"]).to include("Price")
    end

    it "returns 400 when title exceeds 100 characters" do
      params = {
        title: "a" * 101,
        quantity: 10,
        price: 99.99
      }

      post "/api/products", params: params

      expect(response).to have_http_status(:bad_request)

      json_response = JSON.parse(response.body)
      expect(json_response["status"]).to eq("error")
      expect(json_response["error"]["code"]).to eq("INVALID_INPUT")
      expect(json_response["error"]["message"]).to include("Title")
    end

    it "returns 400 when description exceeds 500 characters" do
      params = {
        title: "Test Product",
        description: "a" * 501,
        quantity: 10,
        price: 99.99
      }

      post "/api/products", params: params

      expect(response).to have_http_status(:bad_request)

      json_response = JSON.parse(response.body)
      expect(json_response["status"]).to eq("error")
      expect(json_response["error"]["code"]).to eq("INVALID_INPUT")
      expect(json_response["error"]["message"]).to include("Description")
    end

    it "returns 400 when quantity is negative" do
      params = {
        title: "Test Product",
        quantity: -5,
        price: 99.99
      }

      post "/api/products", params: params

      expect(response).to have_http_status(:bad_request)

      json_response = JSON.parse(response.body)
      expect(json_response["status"]).to eq("error")
      expect(json_response["error"]["code"]).to eq("INVALID_INPUT")
      expect(json_response["error"]["message"]).to include("Quantity")
    end

    it "returns 400 when price is negative" do
      params = {
        title: "Test Product",
        quantity: 10,
        price: -50.0
      }

      post "/api/products", params: params

      expect(response).to have_http_status(:bad_request)

      json_response = JSON.parse(response.body)
      expect(json_response["status"]).to eq("error")
      expect(json_response["error"]["code"]).to eq("INVALID_INPUT")
      expect(json_response["error"]["message"]).to include("Price")
    end

    it "returns 400 when price is zero" do
      params = {
        title: "Test Product",
        quantity: 10,
        price: 0
      }

      post "/api/products", params: params

      expect(response).to have_http_status(:bad_request)

      json_response = JSON.parse(response.body)
      expect(json_response["status"]).to eq("error")
      expect(json_response["error"]["code"]).to eq("INVALID_INPUT")
    end

    it "returns 400 when title is empty string" do
      params = {
        title: "",
        quantity: 10,
        price: 99.99
      }

      post "/api/products", params: params

      expect(response).to have_http_status(:bad_request)

      json_response = JSON.parse(response.body)
      expect(json_response["status"]).to eq("error")
      expect(json_response["error"]["code"]).to eq("INVALID_INPUT")
    end
  end

  describe "data persistence" do
    it "stores the product in the database" do
      expect {
        post "/api/products", params: {
          title: "Database Test",
          quantity: 25,
          price: 49.99
        }
      }.to change(Product, :count).by(1)

      product = Product.last
      expect(product.title).to eq("Database Test")
      expect(product.quantity).to eq(25)
      expect(product.price).to eq(49.99)
    end

    it "stores product with all attributes" do
      post "/api/products", params: {
        title: "Full Product",
        description: "A complete product with description",
        quantity: 100,
        price: 299.99
      }

      product = Product.last
      expect(product.title).to eq("Full Product")
      expect(product.description).to eq("A complete product with description")
      expect(product.quantity).to eq(100)
      expect(product.price).to eq(299.99)
    end
  end

  describe "response format" do
    it "returns JSON with correct structure" do
      post "/api/products", params: {
        title: "Format Test",
        quantity: 5,
        price: 25.0
      }

      json_response = JSON.parse(response.body)

      expect(json_response).to have_key("status")
      expect(json_response).to have_key("data")
      expect(json_response["data"]).to have_key("id")
      expect(json_response["data"]).to have_key("title")
      expect(json_response["data"]).to have_key("quantity")
      expect(json_response["data"]).to have_key("price")
      expect(json_response["data"]).to have_key("createdAt")
    end

    it "returns timestamp in ISO8601 format" do
      post "/api/products", params: {
        title: "Timestamp Test",
        quantity: 5,
        price: 25.0
      }

      json_response = JSON.parse(response.body)
      timestamp = json_response["data"]["createdAt"]

      expect(timestamp).to match(/\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}Z/)
    end
  end
end
