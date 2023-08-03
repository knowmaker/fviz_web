# frozen_string_literal: true

class ApplicationController < ActionController::API
  attr_reader :current_user

  def authorize_request
    header = request.headers['Authorization']
    token = header.split(' ').last if header
    begin
      # @decoded = JsonWebToken.decode(token)
      @decoded = decode(token)
      @current_user = User.find(@decoded[:email])
    rescue ActiveRecord::RecordNotFound, JWT::DecodeError
      render json: 'Unauthorized', status: :unauthorized
    end
  end

  private

  SECRET_KEY = Rails.application.credentials.secret_key_base
  def decode(token)
    decoded = JWT.decode(token, SECRET_KEY)[0]
    HashWithIndifferentAccess.new(decoded)
  rescue JWT::DecodeError
    nil
  end
end
