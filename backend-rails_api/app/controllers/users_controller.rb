# frozen_string_literal: true

# Контроллер для контроля обработки пользовательских регистраций и авторизаций
class UsersController < ApplicationController
  include UserHelper
  before_action :authorize_request, only: %i[profile update destroy]

  # Метод регистрации пользователя
  def register
    user = User.new(user_params)
    user.confirmation_token = SecureRandom.urlsafe_base64.to_s

    if user.save
      user.password = hash_password(params[:user][:password])
      user.save

      # Высылается письмо для подтверждения почты
      UserMailer.confirmation_email(user).deliver_now
      # Через 30 мин удаляется ссылка на подтверждение
      ResetConfirmationTokenJob.set(wait: 30.minutes).perform_later(user.id_user)

      render json: { data: user }, status: :created
    else
      render json: { error: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # Метод авторизации пользователя
  def login
    @user = User.find_by(email: params[:user][:email])

    if @user&.confirmed && validate_password(params[:user][:password], @user.password)

      # token = JsonWebToken.encode(user_id: @user.id)
      token = encode(id_user: @user.id_user)
      render json: { data: token }, status: :ok
    elsif !@user
      render json: { error: ['Пользователь не найден'] }, status: :not_found
    elsif !@user.confirmed
      render json: { error: ['Email не подтвержден'] }, status: :unauthorized
    else
      render json: { error: ['Неправильный логин или пароль'] }, status: :unauthorized
    end
  end

  # Метод получения данных пользователя
  def profile
    render json: { data: @current_user }, status: :ok
  end

  # Метод для обновления данных пользователя
  def update
    if @current_user.update(user_params)
      if params[:user][:password].present?
        @current_user.password = hash_password(params[:user][:password])
        @current_user.save
      end
      render json: { data: @current_user }, status: :ok
    else
      render json: { error: @current_user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # Метод для подтвержения почты после регистрации пользователя
  def confirm
    user = User.find_by(confirmation_token: params[:confirmation_token])

    if user
      user.update(confirmed: true, confirmation_token: nil)
      render json: 'Email успешно подтвержден', status: :ok
    else
      render json: 'Некорректная ссылка', status: :unprocessable_entity
    end
  end

  # Метод для сброса пароля по почте пользователя
  def reset
    user = User.find_by(email: params[:user][:email])

    if user&.confirmed
      user.confirmation_token = SecureRandom.urlsafe_base64.to_s
      user.save

      # Высылается ссылка для сброса пароля
      UserMailer.reset_password_email(user).deliver_now
      # Через 30 мин удаляется ссылка на сброс
      ResetConfirmationTokenJob.set(wait: 30.minutes).perform_later(user.id_user)

      head :ok
    elsif user && !user.confirmed
      render json: { error: ['Email не подтвержден'] }, status: :unauthorized
    else
      render json: { error: ['Пользователь не найден'] }, status: :not_found
    end
  end

  # Метод для создания нового пароля пользователя
  def new_password
    user = User.find_by(confirmation_token: params[:confirmation_token])

    if user
      new_password = generate_random_password
      user.password = hash_password(new_password)
      user.confirmation_token = nil
      user.save

      # Высылается новый пароль
      UserMailer.new_password_email(user, new_password).deliver_now

      render json: 'Новый пароль сгенерирован и выслан на почту', status: :ok
    else
      render json: 'Некорректная ссылка', status: :unprocessable_entity
    end
  end

  # Метод для удаления аккаунта пользователя.
  def destroy
    @current_user.destroy
    head :ok
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :last_name, :first_name, :patronymic)
  end

  SECRET_KEY = Rails.application.secrets.secret_key_base.to_s

  def encode(payload, exp = 24.hours.from_now)
    payload[:exp] = exp.to_i
    JWT.encode(payload, SECRET_KEY)
  end
end
