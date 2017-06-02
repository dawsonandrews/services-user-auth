require "spec_helper"

RSpec.describe "Auth Tokens", type: :api do
  before { UserAuth::Models::User.create(email: "pete@example.org", password: "mcflurrys") }
  context "when invalid" do
    it "returns bad request" do
      post "/token", email: "pete@example.org", password: "mcfl"
      expect(http_status).to eq(404)
      expect(response_json["error_code"]).to eq("not_found")
    end
  end

  context "when valid" do
    it "provides a token" do
      post "/token", email: "pete@example.org", password: "mcflurrys"
      expect(http_status).to eq(200)

      payload = UserAuth::Token.new.parse(response_json["token"])
      user = UserAuth::Models::User[payload["user_id"]]
      expect(user.email).to eq(response_json["data"]["email"])

      expect(response_json["refresh_token"]).to eq(user.refresh_tokens.first.token)
    end
  end
end
