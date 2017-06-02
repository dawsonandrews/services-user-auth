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
      post "/signup", email: "pete@example.org", password: "mcflurrys"
      expect(http_status).to eq(201)

      payload = UserAuth::Token.new.parse(response_json["token"])
      expect(payload["user_id"]).to be_a(Numeric)
    end
  end
end
