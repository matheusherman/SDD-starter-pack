require "rails_helper"

RSpec.describe "DELETE /api/products/:id", type: :request do
  let(:admin_user) { create(:admin) }
  let(:normal_user) { create(:user) }
  let(:product) { create(:product) }
  let(:admin_token) do
    JwtToken.generate(user_id: admin_user.id, role: admin_user.role)
  end
  let(:user_token) do
    JwtToken.generate(user_id: normal_user.id, role: normal_user.role)
  end

  describe "successful deletion" do
    it "deletes product with admin token" do
      admin_user  # Force creation
      product_id = product.id  # Force product creation

      initial_count = Product.count
      delete "/api/products/#{product_id}", headers: { "Authorization" => "Bearer #{admin_token}" }

      expect(response).to have_http_status(:ok)
      expect(Product.count).to eq(initial_count - 1)
      json_response = JSON.parse(response.body)
      expect(json_response["status"]).to eq("success")
      expect(json_response["data"]["id"]).to eq(product_id)
      expect(json_response["data"]["message"]).to eq("Product deleted successfully")
    end

    it "deleted product cannot be retrieved" do
      admin_user  # Force creation

      delete "/api/products/#{product.id}", headers: { "Authorization" => "Bearer #{admin_token}" }

      get "/api/products?sort=created_at&order=asc&limit=100"
      json_response = JSON.parse(response.body)
      
      product_ids = json_response["data"].map { |p| p["id"] }
      expect(product_ids).not_to include(product.id)
    end

    it "returns success response with product id" do
      admin_user  # Force creation

      delete "/api/products/#{product.id}", headers: { "Authorization" => "Bearer #{admin_token}" }

      expect(response).to have_http_status(:ok)
      json_response = JSON.parse(response.body)
      expect(json_response["data"]["id"]).to eq(product.id)
    end
  end

  describe "authorization errors" do
    it "returns 401 without authentication" do
      delete "/api/products/#{product.id}"

      expect(response).to have_http_status(:unauthorized)
      json_response = JSON.parse(response.body)
      expect(json_response["error"]["code"]).to eq("UNAUTHORIZED")
    end

    it "returns 403 with normal user role" do
      delete "/api/products/#{product.id}", headers: { "Authorization" => "Bearer #{user_token}" }

      expect(response).to have_http_status(:forbidden)
      json_response = JSON.parse(response.body)
      expect(json_response["error"]["code"]).to eq("FORBIDDEN")
    end

    it "returns 404 for non-existent product" do
      admin_user  # Force creation

      delete "/api/products/non-existent-id", headers: { "Authorization" => "Bearer #{admin_token}" }

      expect(response).to have_http_status(:not_found)
      json_response = JSON.parse(response.body)
      expect(json_response["error"]["code"]).to eq("NOT_FOUND")
    end
  end
end
