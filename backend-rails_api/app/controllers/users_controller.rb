# frozen_string_literal: true

# Контроллер для контроля обработки пользовательских регистраций и авторизаций
class UsersController < ApplicationController
  before_action :authorize_request, except: %i[create login]
  def create
    user = User.new(user_params)
    if user.save
      render json: user, status: :created
    else
      render json: 'Registering error', status: :unprocessable_entity
    end
  end

  def login
    @user = User.find_by(email: params[:email])
    if @user && @user.attributes.slice('password')['password'] == params[:password]
      # token = JsonWebToken.encode(user_id: @user.id)
      token = encode({user_id: @user.id,email: @user.email})
      render json: token, status: :ok
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
