# TEST ENV VARS
ENV["APP_ENV"] = "test"

require "fast_helper"
require_relative "../config/boot"
require "user_auth"

require_relative "support/api_helper"
require_relative "support/mail_helper"

RSpec.configure do |config|
  config.around(:each) do |example|
    DB.transaction(rollback: :always, auto_savepoint: true) do
      example.run
    end
  end
end
