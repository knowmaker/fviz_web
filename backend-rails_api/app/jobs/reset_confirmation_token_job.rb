# frozen_string_literal: true

# Класс для сброса токена
class ResetConfirmationTokenJob < ApplicationJob
  queue_as :default

  def perform(user_id)
    user = User.find_by(id_user: user_id)
    user.update(confirmation_token: nil) if user&.confirmation_token
    user.destroy unless user&.confirmed
  end
end
