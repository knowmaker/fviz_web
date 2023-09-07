# frozen_string_literal: true

# Контроллер для работы с типами закономерностей
class LawTypesController < ApplicationController
  # before_action :authorize_request
  before_action :set_law_type, only: %i[show update destroy]

  def index
    # unless @current_user.role
    #   render json: {error: ['Only admins can see all law types list']}, status: :unauthorized
    #   return
    # end
    #
    law_types = LawType.all
    render json: {data: law_types}, status: :ok
  end

  def show
    # unless @current_user.role
    #   render json: {error: ['Only admins can see to law type']}, status: :unauthorized
    #   return
    # end

    render json: {data: @law_type}, status: :ok
  end

  def create
    # unless @current_user.role
    #   render json: {error: ['Only admins can create law type']}, status: :unauthorized
    #   return
    # end

    law_type = LawType.new(law_type_params)

    if law_type.save
      render json: {data: law_type}, status: :created
    else
      render json: {error: law_type.errors.full_messages}, status: :unprocessable_entity
    end
  end

  def update
    # unless @current_user.role
    #   render json: {error: ['Only admins can update law type']}, status: :unauthorized
    #   return
    # end

    if @law_type.update(law_type_params)
      render json: {data: @law_type}, status: :ok
    else
      render json: {error: @law_type.errors.full_messages}, status: :unprocessable_entity
    end
  end

  def destroy
    # unless @current_user.role
    #   render json: {error: ['Only admins can delete law type']}, status: :unauthorized
    #   return
    # end

    @law_type.destroy
    head :ok
  end

  private

  def set_law_type
    @law_type = LawType.find(params[:id])
  end

  def law_type_params
    params.require(:law_type).permit(:type_name)
  end
end
