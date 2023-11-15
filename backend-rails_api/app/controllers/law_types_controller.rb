# frozen_string_literal: true

# Контроллер для работы с типами закономерностей
class LawTypesController < ApplicationController
  before_action :authorize_request
  before_action :set_law_type, only: %i[show update destroy]
  before_action :set_locale_content, only: %i[show create update]

  # Метод для получения перечня типов законов
  def index
    law_types = LawType.order(:id_type).all
    render json: { data: law_types }, status: :ok
  end

  # Метод для получения одного типа закона. Параметр - id тип закона
  def show
    if @law_type
      Globalize.with_locale(@locale_content) do
        render json: { data: @law_type }, status: :ok
      end
    else
      render json: { error: [I18n.t('errors.law_types.not_found')] }, status: :not_found
    end
  end

  # Метод для создания нового типа закона
  def create
    unless @current_user.role
      render json: { error: [I18n.t('errors.law_types.admin_forbidden')] }, status: :forbidden
      return
    end

    Globalize.with_locale(@locale_content) do
      law_type = LawType.new(law_type_params)

      if law_type.save
        render json: { data: law_type }, status: :created
      else
        render json: { error: law_type.errors.full_messages }, status: :unprocessable_entity
      end
    end
  end

  # Метод для обновления параметров типа закона. Параметр - id тип закона
  def update
    unless @current_user.role
      render json: { error: [I18n.t('errors.law_types.admin_forbidden')] }, status: :forbidden
      return
    end

    if @law_type
      Globalize.with_locale(@locale_content) do
        if @law_type.update(law_type_params)
          render json: { data: @law_type }, status: :ok
        else
          render json: { error: @law_type.errors.full_messages }, status: :unprocessable_entity
        end
      end
    else
      render json: { error: [I18n.t('errors.law_types.not_found')] }, status: :not_found
    end
  end

  # Метод для удаления типа закона. Параметр - id тип закона
  def destroy
    unless @current_user.role
      render json: { error: [I18n.t('errors.law_types.admin_forbidden')] }, status: :forbidden
      return
    end

    if @law_type
      @law_type.destroy
      head :ok
    else
      render json: { error: [I18n.t('errors.law_types.not_found')] }, status: :not_found
    end
  end

  private

  def set_law_type
    @law_type = LawType.find_by(id_type: params[:id])
  end

  def law_type_params
    params.require(:law_type).permit(:type_name, :color)
  end

  def set_locale_content
    @locale_content = params[:locale_content] || I18n.locale
    @locale_content = @locale_content.to_sym
  end
end
