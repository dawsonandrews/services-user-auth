# TEST ENV VARS
ENV["APP_ENV"] = "test"

require "fast_helper"
require_relative "../config/boot"
require "user_auth"

require "da/testing/support/api_helper"
require_relative "support/mail_helper"

module RackAppLoader
  def app
    # Load entire Rack application stack
    Rack::Builder.parse_file(File.expand_path(File.join(__dir__, "..", "config.ru"))).first
  end
end

RSpec.configure do |config|
  config.include RackAppLoader

  config.around(:each) do |example|
    DB.transaction(rollback: :always, auto_savepoint: true) do
      example.run
    end
  end
end
