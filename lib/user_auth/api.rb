require_relative "../../config/boot"
require_relative "./user"
require_relative "./token"
require_relative "./password_verifier"
require "sinatra/base"

module UserAuth
  class Api < Sinatra::Base
    before { content_type(:json) }

    error Sequel::ValidationFailed do |record|
      halt 422, json(
        errors: record.errors,
        error_code: "validation_failed",
        message: "Validation failed"
      )
    end

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

      json(token: Token.new.create(user_id: user.id, exp: Time.now.to_i + 3600))
    end

    def params
      super.symbolize_keys.with_indifferent_access
    end

    def json(data)
      JSON.dump(data)
    end
  end
end
