require "bcrypt"

module UserAuth
  class PasswordHasher
    def hash_plaintext(plaintext)
      BCrypt::Password.create(plaintext)
    end
  end
end
