require "rails_helper"

RSpec.describe "GET /api/products", type: :request do
  describe "list all products" do
    before do
      create_list(:product, 25)
    end

    it "lists products with default pagination" do
      get "/api/products"

      expect(response).to have_http_status(:ok)
      json_response = JSON.parse(response.body)

      expect(json_response["status"]).to eq("success")
      expect(json_response["data"]).to be_an(Array)
      expect(json_response["data"].length).to eq(10)
      expect(json_response["meta"]["total"]).to eq(25)
      expect(json_response["meta"]["page"]).to eq(1)
      expect(json_response["meta"]["limit"]).to eq(10)
    end

    it "lists products with custom page and limit" do
      get "/api/products?page=2&limit=5"

      json_response = JSON.parse(response.body)
      expect(json_response["data"].length).to eq(5)
      expect(json_response["meta"]["page"]).to eq(2)
      expect(json_response["meta"]["limit"]).to eq(5)
    end

    it "respects maximum limit of 100" do
      get "/api/products?limit=200"

      json_response = JSON.parse(response.body)
      expect(json_response["meta"]["limit"]).to eq(100)
    end

    it "sorts by price ascending" do
      p1 = create(:product, price: 10.0)
      p2 = create(:product, price: 20.0)
      p3 = create(:product, price: 5.0)

      get "/api/products?sort=price&order=asc&limit=100"

      json_response = JSON.parse(response.body)
      prices = json_response["data"].map { |p| p["price"] }.compact
      
      expect(prices[0]).to be <= prices[1]
      expect(prices[1]).to be <= prices[2]
    end

    it "sorts by created_at descending" do
      get "/api/products?sort=created_at&order=desc&limit=100"

      json_response = JSON.parse(response.body)
      expect(json_response["data"]).to be_an(Array)
    end

    it "returns empty list when no products exist" do
      Product.destroy_all

      get "/api/products"

      json_response = JSON.parse(response.body)
      expect(json_response["data"]).to eq([])
      expect(json_response["meta"]["total"]).to eq(0)
    end

    it "calculates total pages correctly" do
      get "/api/products?limit=10"

      json_response = JSON.parse(response.body)
      expect(json_response["meta"]["totalPages"]).to eq(3)
    end

    it "returns 400 with invalid page" do
      get "/api/products?page=0"

      expect(response).to have_http_status(:bad_request)
      json_response = JSON.parse(response.body)
      expect(json_response["error"]["code"]).to eq("INVALID_INPUT")
    end

    it "returns 400 with invalid limit" do
      get "/api/products?limit=0"

      expect(response).to have_http_status(:bad_request)
    end

    it "returns 400 with invalid sort parameter" do
      get "/api/products?sort=invalid"

      expect(response).to have_http_status(:bad_request)
      json_response = JSON.parse(response.body)
      expect(json_response["error"]["message"]).to include("sort")
    end
  end
end
