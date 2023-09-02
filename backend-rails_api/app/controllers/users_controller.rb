# frozen_string_literal: true

# Контроллер для контроля обработки пользовательских регистраций и авторизаций
class UsersController < ApplicationController
  include UserHelper
  before_action :authorize_request, except: %i[create login confirm reset new_password]

  def create
    user = User.find_by(email: params[:user][:email])
    if user
      render json: { message: 'User already exists', data: nil }, status: :unprocessable_entity
    else
      user = User.new(user_params)
      user.password = hash_password(params[:user][:password])
      user.confirmation_token = SecureRandom.urlsafe_base64.to_s

      if user.save
        ConfirmationMailer.confirmation_email(user).deliver_now
        ResetConfirmationTokenJob.set(wait: 30.minutes).perform_later(user.id_user)

        render json: { message: 'User created successfully', data: user }, status: :created
      else
        render json: { message: 'Validation failed', errors: user.errors.full_messages }, status: :unprocessable_entity
      end
    end
  end

  def login
    @user = User.find_by(email: params[:user][:email])

    if @user&.confirmed && validate_password(params[:user][:password], @user.password)

      # token = JsonWebToken.encode(user_id: @user.id)
      token = encode(id_user: @user.id_user)
      render json: { message: 'Login successful', data: token }, status: :ok
    elsif !@user
      render json: { message: 'User not found', data: nil }, status: :not_found
    elsif !@user.confirmed
      render json: { message: 'Email not confirmed', data: nil }, status: :unauthorized
    else
      render json: { message: 'Invalid credentials', data: nil }, status: :unauthorized
    end
  end

  def show
    render json: { message: 'User details', data: @current_user }, status: :ok
  end

  def update
    if @current_user.update(user_params)
      render json: { message: 'User updated successfully', data: @current_user }, status: :ok
    else
      render json: { message: 'Update failed', errors: @current_user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def confirm
    user = User.find_by(confirmation_token: params[:confirmation_token])

    if user
      user.update(confirmed: true, confirmation_token: nil)
      render json: { message: 'Email confirmed successfully', data: nil }, status: :ok
    else
      render json: { message: 'Invalid confirmation token', data: nil }, status: :unprocessable_entity
    end
  end

  def reset
    user = User.find_by(email: params[:user][:email])

    if user&.confirmed
      user.confirmation_token = SecureRandom.urlsafe_base64.to_s
      user.save

      ResetPasswordMailer.reset_password_email(user).deliver_now
      ResetConfirmationTokenJob.set(wait: 30.minutes).perform_later(user.id_user)

      render json: { message: 'Reset password email sent', data: nil }, status: :ok
    elsif !user.confirmed
      render json: { message: 'Email not confirmed', data: nil }, status: :unauthorized
    else
      render json: { message: 'User not found', data: nil }, status: :not_found
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

      render json: { message: 'New password generated and sent', data: nil }, status: :ok
    else
      render json: { message: 'Invalid reset token', data: nil }, status: :unprocessable_entity
    end
  end

  def destroy
    @current_user.destroy
    render json: { message: 'User deleted successfully', data: nil }, status: :ok
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
