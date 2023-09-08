module UserHelper
  def hash_password(password)
    Argon2::Password.create(password)
  end

  def validate_password(password, password_hash)
    Argon2::Password.verify_password(password, password_hash)
  end

  def generate_random_password
    charset = Array('A'..'Z') + Array('a'..'z') + Array('0'..'9')
    Array.new(12) { charset.sample }.join
  end
end
