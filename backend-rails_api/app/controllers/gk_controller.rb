# frozen_string_literal: true

# Контроллер для работы с цветами системных уровней
class GkController < ApplicationController
  before_action :authorize_request, except: %i[index]
  before_action :set_gk, only: %i[show update]
  before_action :set_locale_content, only: %i[show update]

  # Метод для получения перечня всех системных уровней
  def index
    gks = Gk.order(:id_gk).all
    render json: { data: gks }, status: :ok
  end

  # Метод для получения одного системного уровня по его id
  def show
    if @gk
      Globalize.with_locale(@locale_content) do
        render json: { data: @gk }, status: :ok
      end
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
      Globalize.with_locale(@locale_content) do
        if @gk.update(gk_params)
          render json: { data: @gk }, status: :ok
        else
          render json: { error: @gk.errors.full_messages }, status: :unprocessable_entity
        end
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

  def set_locale_content
    @locale_content = params[:locale_content] || I18n.locale
    @locale_content = @locale_content.to_sym
  end
end
