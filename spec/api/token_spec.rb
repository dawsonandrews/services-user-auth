require "spec_helper"

RSpec.describe "Auth Tokens", type: :api do
  let!(:user) { UserAuth::Models::User.create(email: "pete@example.org", password: "mcflurrys") }

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
        expect(payload["email"]).to eq(user.email)
        expect(payload["user_id"]).to eq(user.id)

        expect(response_json["token_type"]).to eq("Bearer")
        expect(response_json["refresh_token"]).to eq(user.refresh_tokens.first.token)
      end
    end
  end

  context "grant_type: refresh_token" do
    context "when invalid" do
      it "returns bad request" do
        post "/token", grant_type: "refresh_token", refresh_token: "fake-token"
        expect(http_status).to eq(400)
      end
    end

    context "when valid" do
      let!(:refresh_token) { user.refresh_token! }

      it "provides an access token" do

        post "/token", grant_type: "refresh_token", refresh_token: refresh_token
        expect(http_status).to eq(200)

        payload = UserAuth::Token.new.parse(response_json["token"])
        expect(payload["email"]).to eq(user.email)
        expect(payload["user_id"]).to eq(user.id)

        expect(response_json["token_type"]).to eq("Bearer")
        expect(response_json["refresh_token"]).to eq(user.refresh_tokens.first.token)
      end
    end
  end
end
