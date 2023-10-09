# frozen_string_literal: true

# Класс для рассылок пользователя на тему работы с их аккаунтом
class UserMailer < ApplicationMailer
  def confirmation_email(user)
    @user = user
    mail(to: @user.email, subject: I18n.t('user_mailer.confirmation_email.subject'))
  end

  def new_password_email(user, new_password)
    @user = user
    @new_password = new_password
    mail(to: @user.email, subject: I18n.t('user_mailer.new_password_email.subject'))
  end

  def reset_password_email(user)
    @user = user
    mail(to: @user.email, subject: I18n.t('user_mailer.reset_password_email.subject'))
  end
end
