# TEST ENV VARS
ENV["APP_ENV"] = "test"

require "fast_helper"
require_relative "../config/boot"
require "user_auth"

require_relative "support/api_helper"

RSpec.configure do |config|
  # config.before(:suite) do
  #   # Set mail into test mode
  #   Mail.defaults do
  #     delivery_method :test
  #   end
  # end

  config.around(:each) do |example|
    DB.transaction(rollback: :always, auto_savepoint: true) do
      example.run
    end
  end
end
