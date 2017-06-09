require "fast_helper"
require "user_auth/configuration"

RSpec.describe UserAuth::Configuration do
  it "allows specifying a deliver_mail lambda" do
    subject.deliver_mail = lambda {}
  end

  it "enables signups by default" do
    expect(subject.signups).to be(true)
  end

  it "disables account confirmation by default" do
    expect(subject.account_confirmations).to be(false)
  end
end
