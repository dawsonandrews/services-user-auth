require "spec_helper"

RSpec.describe "Main API", type: :api do
  it "loads" do
    get "/"
    expect(http_status).to eq(200)
    expect(response_json["hello"]).to eq("world")
  end
end
