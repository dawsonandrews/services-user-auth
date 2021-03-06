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
      case params[:grant_type]
      when "password"
        user = User.first(email: params[:username])
        verifier = PasswordVerifier.new(user&.password_digest)

        if user && verifier.verify(params[:password])
          json_user_token(user)
        else
          halt 404, json(error_code: "not_found", message: "Your email / password is incorrect")
        end
      when "refresh_token"
        refresh_token = RefreshToken.first(token: params[:refresh_token])

        if refresh_token
          json_user_token(refresh_token.user)
        else
          halt 400, json(error_code: "bad_request", message: "Invalid refresh_token")
        end
      else
        halt 400, json(error_code: "bad_request", message: "grant_type must be one of password, refresh_token")
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

    post "/recover" do
      user = User.first(email: params[:email])

      if user
        deliver_email(
          to: user.email,
          user: user.to_json,
          template: "password_reset",
          reset_token: build_jwt(user.to_json)
        )
      end

      json({})
    end

    put "/user/attributes/password" do
      warden.authenticate!

      current_user.password_changing = true
      current_user.update(password: params[:password])

      deliver_email(
        to: current_user.email,
        user: current_user.to_json,
        template: "password_updated"
      )

      json_user_token(current_user)
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
