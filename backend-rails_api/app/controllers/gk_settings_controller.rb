class GkSettingsController < ApplicationController
  def index
    gk_settings = GkSetting.all
    render json: gk_settings, status: :ok
  end

  def update
    @gk_setting = GkSetting.find(params[:id])

    if @gk_setting.update(gk_color: params[:gk_setting][:gk_color])
      render json: @gk_setting, status: :ok
    else
      render json: 'Failed to update gk_setting', status: :unprocessable_entity
    end
  end

  private

  def gk_setting_params
    params.require(:gk_setting).permit(:gk_color)
  end
end
