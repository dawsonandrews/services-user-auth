require_relative "./lib/user_auth/api"
require "rack/cors"

use Rack::Deflater
use Rack::Cors do
  allow do
    origins ENV.fetch("ALLOWED_CORS_ORIGINS", "*")
    resource "*", headers: :any, methods: :any, max_age: 2_592_000 # 30 days
  end
end

map("/") { run UserAuth::Api }
