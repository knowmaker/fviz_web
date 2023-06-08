class GkSettingsController < ApplicationController
  def index
    @colors = GkSetting
    render :json => @colors.all
  end

  def update
  end
end
