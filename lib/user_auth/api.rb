require_relative "./models/refresh_token"
require_relative "./models/user"
require_relative "./token"
require_relative "./password_verifier"
require "rack/contrib"
require "sinatra/base"

module UserAuth
  class Api < Sinatra::Base
    use Rack::PostBodyContentTypeParser
    include UserAuth::Models

    enable :raise_errors
    disable :dump_errors, :show_exceptions, :logging, :static

    get "/" do
      json(hello: "world")
    end

    post "/signup" do
      user = User.create(
        email: params[:email],
        password: params[:password],
        info: params.fetch(:info, {})
      )
      deliver_email(
        to: user.email,
        user_id: user.id,
        user: user.full_info,
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

    def params
      super.symbolize_keys.with_indifferent_access
    end

    def deliver_email(options)
      UserAuth.configuration.deliver_mail.call(options)
    end

    def json(data)
      content_type(:json)
      JSON.dump(data)
    end

    def json_user_token(user)
      json(
        token: Token.new.create(user_id: user.id, exp: Time.now.to_i + 3600),
        data: user.full_info,
        refresh_token: user.refresh_token!
      )
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
