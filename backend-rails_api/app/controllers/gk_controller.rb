# frozen_string_literal: true

# Контроллер для работы с цветами системных уровней
class GkController < ApplicationController
  before_action :authorize_request, except: %i[index]
  before_action :set_gk, only: %i[show update]

  # Метод для получения перечня всех системных уровней
  def index
    gks = Gk.order(:id_gk).all
    render json: { data: gks }, status: :ok
  end

  # Метод для получения одного системного уровня по его id
  def show
    if @gk
      render json: { data: @gk }, status: :ok
    else
      render json: { error: [I18n.t('errors.gk.not_found')] }, status: :not_found
    end
  end

  # Метод для обновления параметров системного уровня по его id
  def update
    unless @current_user.role
      render json: { error: [I18n.t('errors.gk.admin_forbidden')] }, status: :forbidden
      return
    end

    if @gk
      if @gk.update(gk_params)
        render json: { data: @gk }, status: :ok
      else
        render json: { error: @gk.errors.full_messages }, status: :unprocessable_entity
      end
    else
      render json: { error: [I18n.t('errors.represents.not_found')] }, status: :not_found
    end
  end

  private

  def set_gk
    @gk = Gk.find_by(id_gk: params[:id])
  end

  def gk_params
    params.require(:gk).permit(:gk_name, :color)
  end
end
