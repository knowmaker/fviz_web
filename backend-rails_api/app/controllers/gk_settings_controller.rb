# frozen_string_literal: true

# Контроллер для получения и работы с настройками цвета слоев
class GkSettingsController < ApplicationController
  before_action :authorize_request, except: %i[index]
  before_action :set_gk_setting, only: [:update]

  def index
    gk_settings = GkSetting.joins(:gk).select('gk_settings.*, gk.*').all
    render json: gk_settings, status: :ok
  end
  #TODO: сделать по аналогии с represent index для авториз. и неавторизован. пользователей

  def update
    if @gk_setting.update(gk_setting_update_params)
      render json: @gk_setting, status: :ok
    else
      render json: 'Failed to update gk_setting', status: :unprocessable_entity
    end
  end

  private

  def set_gk_setting
    @gk_setting = @current_user.gk_settings.find(params[:id])
  end

  def gk_setting_update_params
    params.require(:gk_setting).permit(:gk_color)
  end
end
