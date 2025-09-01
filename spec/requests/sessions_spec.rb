require 'rails_helper'

RSpec.describe "Sessions", type: :request do
  describe "GET /login" do
    it "returns http success" do
      get "/login"
      expect(response).to have_http_status(:success)
    end
  end


  describe "POST /login" do
    it "returns http success (renders login or redirects)" do
      User.create!(name: "Test User", email: "test@example.com", password: "password", password_confirmation: "password")
      post "/login", params: { email: "test@example.com", password: "password" }
      # Accept either success or redirect, depending on implementation
      expect(response).to have_http_status(:success).or have_http_status(:found)
    end
  end

  describe "DELETE /logout" do
    it "returns http redirect (logs out)" do
      delete "/logout"
      expect(response).to have_http_status(:found)
    end
  end

end
