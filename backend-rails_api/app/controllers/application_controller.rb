# frozen_string_literal: true

# Базовый контроллер приложения. Позволяет проверять автооризацию пользователя
class ApplicationController < ActionController::API
  include Locale
  attr_reader :current_user

  # Метод для проведения авторизации пользователя по токену
  # Параметр необходим для возможности доступа к методу без авторизации (по умолчанию нужна)
  def authorize_request(check_current_user: true)
    token = request.headers['Authorization']
    if token
      token = token.split.last
      begin
        @decoded = decode(token)
        @current_user = User.find_by(id_user: @decoded[:id_user])
        # I18n.locale = @current_user.locale
      rescue ActiveRecord::RecordNotFound
        render json: { error: [I18n.t('errors.application.not_found')] }, status: :not_found
      rescue JWT::DecodeError
        render json: { error: [I18n.t('errors.application.token_error')] }, status: :unprocessable_entity
      end
    elsif check_current_user
      render json: { error: [I18n.t('errors.application.token_not_found')] }, status: :unauthorized
    else
      @current_user = nil
    end
  end

  private

  SECRET_KEY = Rails.application.secrets.secret_key_base.to_s
  def decode(token)
    decoded = JWT.decode(token, SECRET_KEY)[0]
    HashWithIndifferentAccess.new(decoded)
  end
end
