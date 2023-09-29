# frozen_string_literal: true

# Контроллер для работы с цветами системных уровней
class GkController < ApplicationController
  before_action :authorize_request, except: %i[index]
  before_action :set_gk, only: %i[show update]

  def index
    gks = Gk.order(:id_gk).all
    render json: { data: gks }, status: :ok
  end

  def show
    # unless @current_user.role
    #   render json: {error: ['Только админ может просматривать слой']}, status: :forbidden
    #   return
    # end

    render json: { data: @gk }, status: :ok
  end

  def update
    # unless @current_user.role
    #   render json: {error: ['Только админ может обновлять законы']}, status: :forbidden
    #   return
    # end

    if @gk.update(gk_params)
      render json: { data: @gk }, status: :ok
    else
      render json: { error: @gk.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def set_gk
    @gk = Gk.find(params[:id])
  end

  def gk_params
    params.require(:gk).permit(:gk_name, :color)
  end
end
