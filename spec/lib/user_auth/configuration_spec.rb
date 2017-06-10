require "fast_helper"
require "user_auth/configuration"

RSpec.describe UserAuth::Configuration do
  it "allows specifying a deliver_mail lambda" do
    subject.deliver_mail = lambda {}
  end

  it "enables signups by default" do
    expect(subject.allow_signups).to be(true)
  end

  it "disables account confirmation by default" do
    expect(subject.require_account_confirmations).to be(false)
  end

  it "defaults token exp to 1 hour" do
    expect(subject.jwt_exp).to be(3600)
  end
end
