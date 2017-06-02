require_relative "./password_hasher"

module UserAuth
  class User < Sequel::Model
    attr_reader :password
    attr_accessor :password_changing

    def validate
      super
      validates_presence :email
      validates_unique :email
      validates_format(/\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, :email, message: "is not a valid email address")
      validates_presence :password if new? || password_changing
      validates_min_length 8, :password if new? || password_changing
    end

    def password=(plaintext)
      @password = plaintext
      self.password_digest = PasswordHasher.new.hash_plaintext(plaintext)
    end

    def email=(email)
      super(email.try(:downcase))
    end
  end
end
