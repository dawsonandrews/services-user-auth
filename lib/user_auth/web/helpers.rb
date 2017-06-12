require "da/core/auth_token"

module UserAuth
  module Web
    module Helpers
      def current_user
        @current_user ||= UserAuth::Models::User.with_pk!(warden.user.user_id)
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
          token_type: "Bearer",
          token: build_jwt(user.to_json),
          refresh_token: user.refresh_token!
        )
      end

      def build_jwt(data)
        exp = Time.now.to_i + UserAuth.configuration.jwt_exp
        AuthToken.new.create(data.merge(exp: exp))
      end
    end
  end
end
