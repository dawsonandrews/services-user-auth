require_relative "./models/refresh_token"
require_relative "./models/user"
require_relative "./web/helpers"
require_relative "./token"
require_relative "./password_verifier"
require "rack/contrib"
require "sinatra/base"
require "token_failure_app"

module UserAuth
  class Api < Sinatra::Base
    use Rack::PostBodyContentTypeParser
    include UserAuth::Models

    enable :raise_errors
    disable :dump_errors, :show_exceptions, :logging, :static

    use Warden::Manager do |manager|
      manager.default_strategies :jwt
      manager.failure_app = ::TokenFailureApp # lib/token_failure_app.rb
    end

    helpers Web::Helpers

    get "/" do
      json(service: "user-auth")
    end

    post "/signup" do
      user = User.create(
        email: params[:email],
        password: params[:password],
        info: params.fetch(:info, {})
      )
      deliver_email(
        to: user.email,
        user: user.to_json,
        template: "user_signup"
      )

      status 201

      json_user_token(user)
    end

    post "/token" do
      user = User.first(email: params[:email])
      verifier = PasswordVerifier.new(user.password_digest)

      if verifier.verify(params[:password])
        json_user_token(user)
      else
        halt 404, json(error_code: "not_found", message: "Your email / password is incorrect")
      end
    end

    put "/user" do
      warden.authenticate!

      update_params = {
        info: params.fetch(:info, {})
      }

      update_params[:email] = params[:email] if params[:email]

      user = current_user.update(update_params)

      json_user_token(user)
    end

    post "/logout" do
      warden.authenticate!
      current_user.clear_refresh_tokens!
      json({})
    end

    error Sequel::ValidationFailed do |record|
      halt 422, json(
        errors: record.errors,
        error_code: "validation_failed",
        message: "Validation failed"
      )
    end

    error Sinatra::NotFound, Sequel::NoMatchingRow do
      halt 404, json(error_code: "not_found", message: "Endpoint '#{request.path}' not found")
    end
  end
end
