class ResetConfirmationTokenJob < ApplicationJob
  queue_as :default

  def perform(user_id)
    user = User.find(user_id)
    user.update(confirmation_token: nil) if user&.confirmation_token
  end
end
