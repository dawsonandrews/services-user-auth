require "spec_helper"

RSpec.describe UserAuth::User, type: :model do
  describe "#fields" do
    it { expect(subject).to respond_to(:email) }
    it { expect(subject).to respond_to(:password) }
    it { expect(subject).to respond_to(:created_at) }
    it { expect(subject).to respond_to(:updated_at) }
  end

  describe "#email" do
    it "ensures presence" do
      subject.email = nil
      expect(subject.valid?).to be false
    end

    it "ensures valid" do
      subject.email = "fake"
      expect(subject.valid?).to be false
    end

    it "is unique" do
      UserAuth::User.create(email: "bob@example.org", password: "mcflurrys")

      new_user = UserAuth::User.new(email: "bob@example.org", password: "mcflurrys")
      expect(new_user.valid?).to be false
    end
  end

  describe "#password" do
    it "ensures presence" do
      user = UserAuth::User.new(email: "bob@bob.com")
      expect(user.valid?).to be false
    end

    it "sets password_digest" do
      user = UserAuth::User.new(email: "bob@bob.com", password: "superduper")
      expect(user.password_digest).not_to be_nil
    end
  end
end
