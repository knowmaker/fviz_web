class ResetPasswordMailer < ApplicationMailer
  def reset_password_email(user)
    @user = user
    mail(to: @user.email, subject: 'Сброс пароля')
  end
end
