require "spec_helper"
require "user_auth/password_verifier"

RSpec.describe "Update password", type: :api do
  let!(:user) { UserAuth::Models::User.create(email: "pete@example.org", password: "mcflurrys") }

  it "ensures min-length" do
    params = { password: "short" }

    put "/user/attributes/password", params, token_header(user)
    expect(http_status).to eq(422)
    expect(response_json["errors"]["password"]).to eq(["is shorter than 8 characters"])
  end

  it "updates" do
    params = { password: "newPassword1" }

    put "/user/attributes/password", params, token_header(user)
    expect(http_status).to eq(200)
    expect(response_json["token"]).not_to be_nil
    expect(response_json["refresh_token"]).not_to be_nil

    expect(last_email.to).to eq(user.email)
    expect(last_email.template).to eq("password_updated")
    expect(last_email.user[:user_id]).to eq(user.id)
    expect(last_email.user[:email]).to eq(user.email)

    verifier = UserAuth::PasswordVerifier.new(user.reload.password_digest)

    expect(verifier.verify("newPassword1")).to be(true)
  end
end
