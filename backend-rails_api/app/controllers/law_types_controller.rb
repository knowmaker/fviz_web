# frozen_string_literal: true

# Контроллер для работы с типами закономерностей
class LawTypesController < ApplicationController
  before_action :authorize_request
  before_action :set_law_type, only: %i[show update destroy]

  def index
    law_types = LawType.order(:id_type).all
    render json: { data: law_types }, status: :ok
  end

  def show
    # unless @current_user.role
    #   render json: {error: ['Только админ может просматривать тип закона']}, status: :forbidden
    #   return
    # end

    if @law_type
      render json: { data: @law_type }, status: :ok
    else
      render json: { error: ['Тип закона не найден'] }, status: :not_found
    end
  end

  def create
    # unless @current_user.role
    #   render json: {error: ['Только админ может создавать законы']}, status: :forbidden
    #   return
    # end

    law_type = LawType.new(law_type_params)

    if law_type.save
      render json: { data: law_type }, status: :created
    else
      render json: { error: law_type.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    # unless @current_user.role
    #   render json: {error: ['Только админ может обновлять законы']}, status: :forbidden
    #   return
    # end

    if @law_type
      if @law_type.update(law_type_params)
        render json: { data: @law_type }, status: :ok
      else
        render json: { error: @law_type.errors.full_messages }, status: :unprocessable_entity
      end
    else
      render json: { error: ['Тип закона не найден'] }, status: :not_found
    end
  end

  def destroy
    # unless @current_user.role
    #   render json: {error: ['Только админ может удалять законы']}, status: :forbidden
    #   return
    # end

    if @law_type
      @law_type.destroy
      head :ok
    else
      render json: { error: ['Тип закона не найден'] }, status: :not_found
    end
  end

  private

  def set_law_type
    @law_type = LawType.find_by(id_type: params[:id])
  end

  def law_type_params
    params.require(:law_type).permit(:type_name, :color)
  end
end
