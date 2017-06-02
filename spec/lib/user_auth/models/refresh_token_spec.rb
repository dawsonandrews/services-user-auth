require "spec_helper"

RSpec.describe UserAuth::Models::RefreshToken, type: :model do
  describe "#fields" do
    it { expect(subject).to respond_to(:user_id) }
    it { expect(subject).to respond_to(:token) }
    it { expect(subject).to respond_to(:revoked_at) }
    it { expect(subject).to respond_to(:created_at) }
    it { expect(subject).to respond_to(:updated_at) }
  end

  it "creates a token on save" do
    user = UserAuth::Models::User.create(email: "pete@example.org", password: "mcflurrys")
    rt = described_class.new(user_id: user.id).save
    expect(rt.token).not_to be_nil
  end
end
