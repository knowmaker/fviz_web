# frozen_string_literal: true

# Класс для рассылок пользователя на тему работы с их аккаунтом
class UserMailer < ApplicationMailer
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.confirmation_email.subject
  #
  def confirmation_email(user)
    @user = user
    mail(to: @user.email, subject: 'Подтверждение почты')
  end

  def new_password_email(user, new_password)
    @user = user
    @new_password = new_password
    mail(to: @user.email, subject: 'Новый пароль')
  end

  def reset_password_email(user)
    @user = user
    mail(to: @user.email, subject: 'Сброс пароля')
  end
end
