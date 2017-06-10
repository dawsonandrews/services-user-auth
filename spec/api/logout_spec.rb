require "spec_helper"

RSpec.describe "Logout", type: :api do
  it "deletes all refresh tokens" do
    post "/signup", email: "pete@example.org", password: "mcflurrys1"

    user = UserAuth::Models::User.last

    post "/logout", nil, token_header(user)
    expect(http_status).to eq(200)
    expect(response_json).to eq({})
    expect(user.refresh_tokens_dataset.count).to eq(0)
  end
end
