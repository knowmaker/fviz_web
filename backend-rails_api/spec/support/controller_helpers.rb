module ControllerHelpers
  SECRET_KEY = Rails.application.secrets.secret_key_base.to_s
  def encode(payload, exp = 24.hours.from_now)
    payload[:exp] = exp.to_i
    JWT.encode(payload, SECRET_KEY)
  end
  def user_login(id_user)
    encode(id_user: id_user)
  end
end