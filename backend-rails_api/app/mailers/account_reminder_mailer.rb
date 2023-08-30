class AccountReminderMailer < ApplicationMailer
  def reminder_email(user)
    @user = user
    mail(to: @user.email, subject: 'Просьба войти в систему для сохранения аккаунта')
  end
end
