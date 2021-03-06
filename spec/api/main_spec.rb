require "spec_helper"

RSpec.describe "Main API", type: :api do
  it "loads" do
    get "/"
    expect(http_status).to eq(200)
    expect(response_json["service"]).to eq("user-auth")
  end
end
