require "spec_helper"

RSpec.describe "Updating user info", type: :api do
  let(:user) { UserAuth::Models::User.create(email: "pete@example.org", password: "mcflurrys") }

  context "when invalid" do
    it "returns unprocessable entity" do
      params = { email: "" }

      put "/user", params, token_header(user)
      expect(http_status).to eq(422)
      expect(response_json["error_code"]).to eq("validation_failed")
    end
  end

  context "when valid" do
    it "updates the users details" do
      params = { info: { name: "Jean" } }
      put "/user", params, token_header(user)
      expect(http_status).to eq(200)

      payload = UserAuth::Token.new.parse(response_json["token"])
      expect(payload["name"]).to eq("Jean")
      expect(payload["email"]).to eq("pete@example.org")
    end
  end
end
