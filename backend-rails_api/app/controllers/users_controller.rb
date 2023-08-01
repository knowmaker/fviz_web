class UsersController < ApplicationController
  before_action :authorize_request, except: :create
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

    if @user && @user.authenticate(params[:password])
      # token = JsonWebToken.encode(user_id: @user.id)
      token = encode(user_id: @user.id)
      render json: token, status: :ok
    else
      render json: 'Invalid credentials', status: :unauthorized
    end
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
    params.require(:user).permit(:email, :password, :password_confirmation, :last_name, :first_name, :patronymic)
  end

  SECRET_KEY = Rails.application.credentials.secret_key_base

  def encode(payload, exp = 24.hours.from_now)
    payload[:exp] = exp.to_i
    JWT.encode(payload, SECRET_KEY)
  end

end
