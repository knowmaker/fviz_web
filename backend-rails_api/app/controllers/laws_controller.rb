# frozen_string_literal: true

# Контроллер для работы с закономерностями
class LawsController < ApplicationController
  before_action :authorize_request
  before_action :set_law, only: %i[show update destroy]

  # Метод для получения перечня личных законов пользователя
  def index
    laws = @current_user.laws.order(:id_law).all

    render json: { data: laws }, status: :ok
  end

  # Метод для получения одного закона пользователя. Параметр - id закона
  def show
    if @law
      render json: { data: @law }, status: :ok
    else
      render json: { error: [I18n.t('errors.laws.not_found')] }, status: :not_found
    end
  end

  # Метод для создания нового закона пользователя
  def create
    law = @current_user.laws.new(law_params)

    if law.save
      render json: { data: law }, status: :created
    else
      render json: { error: law.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # Метод для обновления параметров закона пользователя. Параметр - id закона
  def update
    if @law
      if @law.update(law_params)
        render json: { data: @law }, status: :ok
      else
        render json: { error: @law.errors.full_messages }, status: :unprocessable_entity
      end
    else
      render json: { error: [I18n.t('errors.laws.not_found')] }, status: :not_found
    end
  end

  # Метод для удаления закона пользователя. Параметр - id закона
  def destroy
    if @law
      @law.destroy
      head :ok
    else
      render json: { error: [I18n.t('errors.laws.not_found')] }, status: :not_found
    end
  end

  private

  def set_law
    @law = @current_user.laws.find_by(id_law: params[:id])
  end

  def law_params
    params.require(:law).permit(:law_name, :first_element, :second_element, :third_element, :fourth_element, :id_type)
  end
end
