require "securerandom"

module UserAuth
  module Models
    class RefreshToken < Sequel::Model
      many_to_one :user

      def before_save
        self.token ||= SecureRandom.hex(32)
      end
    end
  end
end
