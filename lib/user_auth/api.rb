require_relative "../../config/boot"
require_relative "./models/refresh_token"
require_relative "./models/user"
require_relative "./token"
require_relative "./password_verifier"
require "sinatra/base"

module UserAuth
  class Api < Sinatra::Base
    include UserAuth::Models

    before { content_type(:json) }

    get "/" do
      json(hello: "world")
    end

    post "/signup" do
      user = User.create(
        email: params[:email],
        password: params[:password],
        info: params.fetch(:info, {})
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

    def json(data)
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
  end
end
