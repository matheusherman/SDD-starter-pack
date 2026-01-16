require "rails_helper"

RSpec.describe "PATCH /api/products/:id", type: :request do
  let(:admin_user) { create(:admin) }
  let(:normal_user) { create(:user) }
  let(:product) { create(:product) }
  let(:admin_token) do
    JwtToken.generate(user_id: admin_user.id, role: admin_user.role)
  end
  let(:user_token) do
    JwtToken.generate(user_id: normal_user.id, role: normal_user.role)
  end

  describe "successful update" do
    it "updates product with admin token" do
      admin_user  # Force creation to ensure admin exists

      params = {
        title: "Updated Title",
        price: 149.99
      }

      patch "/api/products/#{product.id}", params: params, headers: { "Authorization" => "Bearer #{admin_token}" }

      expect(response).to have_http_status(:ok)
      json_response = JSON.parse(response.body)
      expect(json_response["data"]["title"]).to eq("Updated Title")
      expect(json_response["data"]["price"]).to eq(149.99)
    end

    it "updates only title" do
      admin_user  # Force creation

      original_price = product.price
      params = { title: "New Title" }

      patch "/api/products/#{product.id}", params: params, headers: { "Authorization" => "Bearer #{admin_token}" }

      json_response = JSON.parse(response.body)
      expect(json_response["data"]["title"]).to eq("New Title")
      expect(json_response["data"]["price"]).to eq(original_price.to_f)
    end

    it "updates only price" do
      admin_user  # Force creation

      original_title = product.title
      params = { price: 199.99 }

      patch "/api/products/#{product.id}", params: params, headers: { "Authorization" => "Bearer #{admin_token}" }

      json_response = JSON.parse(response.body)
      expect(json_response["data"]["title"]).to eq(original_title)
      expect(json_response["data"]["price"]).to eq(199.99)
    end

    it "refreshes updatedAt timestamp" do
      admin_user  # Force creation

      original_updated_at = product.updated_at
      sleep(1)

      patch "/api/products/#{product.id}", params: { title: "Updated" }, headers: { "Authorization" => "Bearer #{admin_token}" }

      json_response = JSON.parse(response.body)
      updated_at = Time.parse(json_response["data"]["updatedAt"])
      
      expect(updated_at.to_i).to be > original_updated_at.to_i
    end

    it "updates all fields" do
      admin_user  # Force creation

      params = {
        title: "All Updated",
        description: "New description",
        quantity: 100,
        price: 299.99
      }

      patch "/api/products/#{product.id}", params: params, headers: { "Authorization" => "Bearer #{admin_token}" }

      json_response = JSON.parse(response.body)
      expect(json_response["data"]["title"]).to eq("All Updated")
      expect(json_response["data"]["description"]).to eq("New description")
      expect(json_response["data"]["quantity"]).to eq(100)
      expect(json_response["data"]["price"]).to eq(299.99)
    end
  end

  describe "authorization errors" do
    it "returns 401 without authentication" do
      params = { title: "Updated" }

      patch "/api/products/#{product.id}", params: params

      expect(response).to have_http_status(:unauthorized)
      json_response = JSON.parse(response.body)
      expect(json_response["error"]["code"]).to eq("UNAUTHORIZED")
    end

    it "returns 403 with normal user role" do
      params = { title: "Updated" }

      patch "/api/products/#{product.id}", params: params, headers: { "Authorization" => "Bearer #{user_token}" }

      expect(response).to have_http_status(:forbidden)
      json_response = JSON.parse(response.body)
      expect(json_response["error"]["code"]).to eq("FORBIDDEN")
    end

    it "returns 404 for non-existent product" do
      admin_user  # Force creation

      patch "/api/products/non-existent-id", params: { title: "Updated" }, headers: { "Authorization" => "Bearer #{admin_token}" }

      expect(response).to have_http_status(:not_found)
      json_response = JSON.parse(response.body)
      expect(json_response["error"]["code"]).to eq("NOT_FOUND")
    end
  end

  describe "validation errors" do
    it "returns 400 with invalid title length" do
      admin_user  # Force creation

      params = { title: "a" * 101 }

      patch "/api/products/#{product.id}", params: params, headers: { "Authorization" => "Bearer #{admin_token}" }

      expect(response).to have_http_status(:bad_request)
      json_response = JSON.parse(response.body)
      expect(json_response["error"]["code"]).to eq("INVALID_INPUT")
    end

    it "returns 400 with negative quantity" do
      admin_user  # Force creation

      params = { quantity: -10 }

      patch "/api/products/#{product.id}", params: params, headers: { "Authorization" => "Bearer #{admin_token}" }

      expect(response).to have_http_status(:bad_request)
    end

    it "returns 400 with zero price" do
      admin_user  # Force creation

      params = { price: 0 }

      patch "/api/products/#{product.id}", params: params, headers: { "Authorization" => "Bearer #{admin_token}" }

      expect(response).to have_http_status(:bad_request)
    end

    it "returns 400 with negative price" do
      admin_user  # Force creation

      params = { price: -50 }

      patch "/api/products/#{product.id}", params: params, headers: { "Authorization" => "Bearer #{admin_token}" }

      expect(response).to have_http_status(:bad_request)
    end

    it "returns 400 with description exceeding 500 characters" do
      admin_user  # Force creation

      params = { description: "a" * 501 }

      patch "/api/products/#{product.id}", params: params, headers: { "Authorization" => "Bearer #{admin_token}" }

      expect(response).to have_http_status(:bad_request)
    end
  end
end
