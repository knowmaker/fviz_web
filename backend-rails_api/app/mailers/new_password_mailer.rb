class NewPasswordMailer < ApplicationMailer
  def new_password_email(user, new_password)
    @user = user
    @new_password = new_password
    mail(to: @user.email, subject: 'Новый пароль')
  end
end
