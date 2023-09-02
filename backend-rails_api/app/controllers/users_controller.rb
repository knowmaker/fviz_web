# frozen_string_literal: true

# Контроллер для контроля обработки пользовательских регистраций и авторизаций
class UsersController < ApplicationController
  include UserHelper
  before_action :authorize_request, except: %i[create login confirm reset new_password]
  def create
    user = User.find_by(email: params[:user][:email])
    render json: 'User already exists', status: :unprocessable_entity and return if user

    user = User.new(user_params)
    user.password = hash_password(params[:user][:password])
    user.confirmation_token = SecureRandom.urlsafe_base64.to_s

    if user.save
      ConfirmationMailer.confirmation_email(user).deliver_now
      ResetConfirmationTokenJob.set(wait: 30.minutes).perform_later(user.id_user)

      render json: user, status: :created
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def login
    @user = User.find_by(email: params[:user][:email])

    if @user&.confirmed && validate_password(params[:user][:password], @user.password)

      # token = JsonWebToken.encode(user_id: @user.id)
      token = encode(id_user: @user.id_user)
      render json: token, status: :ok
    elsif !@user
      render json: 'User not found', status: :not_found
    elsif !@user.confirmed
      render json: 'Email not confirmed', status: :unauthorized
    else
      render json: 'Invalid credentials', status: :unauthorized
    end
  end

  def show
    render json: @current_user, status: :ok
  end

  def update
    if @current_user.update(user_params)
      render json: @current_user, status: :ok
    else
      render json: 'Updating error', status: :unprocessable_entity
    end
  end

  def confirm
    user = User.find_by(confirmation_token: params[:confirmation_token])

    if user
      user.update(confirmed: true, confirmation_token: nil)
      render json: 'Email confirmed successfully', status: :ok
    else
      render json: 'Invalid confirmation token', status: :unprocessable_entity
    end
  end

  def reset
    user = User.find_by(email: params[:user][:email])

    if user&.confirmed
      user.confirmation_token = SecureRandom.urlsafe_base64.to_s
      user.save

      ResetPasswordMailer.reset_password_email(user).deliver_now
      ResetConfirmationTokenJob.set(wait: 30.minutes).perform_later(user.id_user)

      render json: 'Reset password email sent', status: :ok
    elsif !user.confirmed
      render json: 'Email not confirmed', status: :unauthorized
    else
      render json: 'User not found', status: :not_found
    end
  end

  def new_password
    user = User.find_by(confirmation_token: params[:confirmation_token])

    if user
      new_password = generate_random_password
      user.password = hash_password(new_password)
      user.confirmation_token = nil
      user.save

      NewPasswordMailer.new_password_email(user, new_password).deliver_now

      render json: 'New password generated and sent', status: :ok
    else
      render json: 'Invalid reset token', status: :unprocessable_entity
    end
  end

  def destroy
    @current_user.destroy
    render json: 'Successfully deleted user', status: :ok
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
