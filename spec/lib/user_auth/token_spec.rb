require "jwt"
require "fast_helper"
require "user_auth/token"
require "active_support/core_ext/integer/time"
require "securerandom"

RSpec.describe UserAuth::Token do
  let(:secret) { SecureRandom.hex }
  subject { described_class.new(secret) }

  describe "Verifying" do
    let(:valid_jwt) { subject.create(user_id: 1, exp: 24.hours.from_now.to_i) }
    let(:expired_jwt) { subject.create(user_id: 1, exp: 5.minutes.ago.to_i) }

    context "with invalid token" do
      it "raises an error" do
        expect do
          subject.parse("gibberish")
        end.to raise_error(UserAuth::Token::ParseError, "Invalid token")
      end
    end

    context "with expired token" do
      it "raises an error" do
        expect do
          subject.parse(expired_jwt)
        end.to raise_error(UserAuth::Token::ParseError, "Token expired")
      end
    end

    context "with valid token" do
      it "returns the payload" do
        payload = subject.parse(valid_jwt)
        expect(payload["user_id"]).to eq(1)
      end
    end
  end
end
