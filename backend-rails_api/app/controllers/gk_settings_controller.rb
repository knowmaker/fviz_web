# frozen_string_literal: true

# Контроллер для получения и работы с настройками цвета слоев
class GkSettingsController < ApplicationController
  before_action :authorize_request
  before_action :set_gk_setting, only: %i[show update]

  def index
    user_id = @current_user ? @current_user.id_user : 1
    gk_settings = GkSetting.where(id_user: user_id).joins(:gk).select('gk_settings.*, gk.*').all
    render json: { data: gk_settings }, status: :ok
  end

  def show
    render json: { data: @gk_setting }, status: :ok
  end

  def update
    if @gk_setting.update(gk_setting_params)
      render json: { data: @gk_setting }, status: :ok
    else
      render json: { error: @gk_setting.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def set_gk_setting
    @gk_setting = @current_user.gk_settings.find(params[:id])
  end

  def gk_setting_params
    params.require(:gk_setting).permit(:gk_bright)
  end
end
