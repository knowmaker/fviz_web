# frozen_string_literal: true

# Базовый контроллер приложения. Позволяет проверять автооризацию пользователя
class ApplicationController < ActionController::API
  attr_reader :current_user

  def authorize_request
    header = request.headers['Authorization']
    token = header.split(' ').last if header
    p token
    begin
      # @decoded = JsonWebToken.decode(token)
      @decoded = decode(token)
      @current_user = User.find(@decoded[:id_user])
    rescue ActiveRecord::RecordNotFound, JWT::DecodeError
      render json: 'Unauthorized', status: :unauthorized
    end
  end

  private

  SECRET_KEY = Rails.application.secrets.secret_key_base.to_s
  def decode(token)
    decoded = JWT.decode(token, SECRET_KEY)[0]
    HashWithIndifferentAccess.new(decoded)
  rescue JWT::DecodeError
    nil
  end
end
