require_relative "./array_mailer"

module MailHelper
  class << self
    def array_mailer
      @array_mailer ||= ArrayMailer.new
    end
  end

  def array_mailer
    MailHelper.array_mailer
  end

  def last_email
    MailHelper.array_mailer.last_email
  end

  def all_emails
    MailHelper.array_mailer.all
  end
end

RSpec.configure do |config|
  config.include MailHelper

  config.before(:each) do
    UserAuth.configure do |c|
      c.deliver_mail = lambda do |options|
        MailHelper.array_mailer.deliver(options)
      end
    end
  end

  config.after(:each) do
    array_mailer.reset
  end
end
