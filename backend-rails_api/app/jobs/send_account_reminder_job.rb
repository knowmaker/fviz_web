class SendAccountReminderJob < ApplicationJob
  queue_as :default

  def perform(user_id)
    user = User.find(user_id)
    return unless user

    # Отправить письмо с напоминанием о входе в систему
    AccountReminderMailer.reminder_email(user).deliver_now
  end
end
