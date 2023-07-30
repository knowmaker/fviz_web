class GkSettingsController < ApplicationController
  before_action :set_gk_setting, only: [:update]

  def index
    gk_settings = GkSetting.joins(:gk).select("gk_settings.*, gk.gk_sign").all
    render json: gk_settings, status: :ok
  end

  def update
    if @gk_setting.update(gk_setting_update_params)
      render json: @gk_setting, status: :ok
    else
      render json: 'Failed to update gk_setting', status: :unprocessable_entity
    end
  end

  private

  def set_gk_setting
    @gk_setting = GkSetting.find(params[:id])
  end

  def gk_setting_update_params
    params.require(:gk_setting).permit(:gk_color)
  end
end
