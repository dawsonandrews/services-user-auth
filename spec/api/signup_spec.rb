require "spec_helper"

RSpec.describe "Signup", type: :api do
  context "when invalid" do
    it "returns errors" do
      post "/signup", email: "pete", password: "mcfl"
      expect(http_status).to eq(422)
      expect(response_json["error_code"]).to eq("validation_failed")
      expect(response_json["errors"]["email"]).to eq(["is not a valid email address"])
      expect(response_json["errors"]["password"]).to eq(["is shorter than 8 characters"])
    end
  end

  context "when valid" do
    it "creates a user and returns a token" do
      post "/signup", email: "pete@example.org", password: "mcflurrys", info: { name: "Pete" }
      expect(http_status).to eq(201)

      expect(response_json["data"]["email"]).to eq("pete@example.org")
      expect(response_json["data"]["name"]).to eq("Pete")

      payload = UserAuth::Token.new.parse(response_json["token"])
      user = UserAuth::Models::User[payload["user_id"]]
      expect(user.info["name"]).to eq("Pete")

      expect(response_json["refresh_token"]).to eq(user.refresh_tokens.first.token)

      expect(last_email.to).to eq("pete@example.org")
      expect(last_email.template).to eq("user_signup")
      expect(last_email.user_id).to eq(payload["user_id"])
      expect(last_email.user[:email]).to eq("pete@example.org")
      expect(last_email.user[:name]).to eq("Pete")
    end
  end
end
