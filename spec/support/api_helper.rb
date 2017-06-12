require "json"
require "base64"
require "rack/test"
require "da/core/auth_token"

module ApiHelper
  include Rack::Test::Methods

  def app
    # Load entire Rack application stack
    Rack::Builder.parse_file(File.expand_path(File.join(__dir__, "..", "..", "config.ru"))).first
  end

  def token_header(user)
    jwt_token = AuthToken.new.create(user.to_json)
    { "HTTP_AUTHORIZATION" => "Bearer #{jwt_token}" }
  end

  # Response helpers

  def http_status
    last_response.status
  end

  # JSON helpers

  def response_json
    JSON.parse(last_response.body)
  end

  def json(hash)
    JSON.dump(hash)
  end
end

RSpec.configure do |config|
  config.include ApiHelper, type: :api
end
