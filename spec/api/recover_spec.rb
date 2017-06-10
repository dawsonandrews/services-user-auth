require "spec_helper"

RSpec.describe "Recover account", type: :api do
  context "when user doesnt exist for email" do
    it "returns successfully" do
      post "/recover", email: "non_existant@example.org"
      expect(http_status).to eq(200)
      expect(response_json).to eq({})
    end
  end

  context "when valid" do
    it "delivers a password reset email" do
      user = UserAuth::Models::User.create(email: "pete@example.org", password: "mcflurrys")

      post "/recover", email: user.email
      expect(http_status).to eq(200)
      expect(response_json).to eq({})

      expect(last_email.to).to eq(user.email)
      expect(last_email.template).to eq("password_reset")
      expect(last_email.user[:user_id]).to eq(user.id)
      expect(last_email.user[:email]).to eq(user.email)

      payload = UserAuth::Token.new.parse(last_email.reset_token)
      expect(payload["user_id"]).to eq(user.id)
      expect(payload["email"]).to eq(user.email)
    end
  end
end
