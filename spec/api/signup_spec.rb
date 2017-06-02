require "spec_helper"

RSpec.describe "Signup", type: :api do
  context "when invalid" do
    it "returns errors" do

    end
  end

  context "when email exists" do
  end

  context "when valid" do
    it "creates a user and returns a token" do
      post "/signup", email: "pete@example.org", password: "mcflurrys"
      expect(http_status).to eq(201)

      payload = User::Auth::Token.new.parse(response_json["token"])
      expect(payload["user_id"]).to be_a(Number)
    end
  end
end
