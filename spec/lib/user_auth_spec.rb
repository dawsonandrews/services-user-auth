require "spec_helper"

RSpec.describe UserAuth do
  describe ".configure" do
    let(:fake_emailer) { double }

    before do
      UserAuth.configure do |config|
        config.deliver_mail = fake_emailer
      end
    end

    it "allows configuration" do
      expect(UserAuth.configuration.deliver_mail).to eq(fake_emailer)
    end

    after(:each) { UserAuth.reset }
  end
end
