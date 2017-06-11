require "spec_helper"

RSpec.describe "Auth Tokens", type: :api do
  before { UserAuth::Models::User.create(email: "pete@example.org", password: "mcflurrys") }

  context "grant_type: unknown" do
    it "returns bad request" do
      post "/token", grant_type: "random"
      expect(http_status).to eq(400)
    end
  end

  context "grant_type: password" do
    context "when username is wrong" do
      it "returns not found" do
        post "/token", grant_type: "password", username: "pete@bad.org"
        expect(http_status).to eq(404)
        expect(response_json["error_code"]).to eq("not_found")
      end
    end

    context "when password is wrong" do
      it "returns not found" do
        post "/token", grant_type: "password", username: "pete@example.org", password: "mcfl"
        expect(http_status).to eq(404)
        expect(response_json["error_code"]).to eq("not_found")
      end
    end

    context "when valid" do
      it "provides an access token" do
        post "/token", grant_type: "password", username: "pete@example.org", password: "mcflurrys"
        expect(http_status).to eq(200)

        payload = UserAuth::Token.new.parse(response_json["token"])
        user = UserAuth::Models::User[payload["user_id"]]
        expect(user.email).to eq(payload["email"])

        expect(response_json["token_type"]).to eq("Bearer")
        expect(response_json["refresh_token"]).to eq(user.refresh_tokens.first.token)
      end
    end
  end

  context "grant_type: refresh_token" do
    context "when invalid" do
      it "returns bad request"
    end

    context "when valid" do
      it "provides an access token"
    end
  end
end
