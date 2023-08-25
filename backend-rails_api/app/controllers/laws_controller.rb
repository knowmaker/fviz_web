# frozen_string_literal: true

# Контроллер для работы с закономерностями
class LawsController < ApplicationController
  before_action :authorize_request
  before_action :set_law, only: %i[show update destroy]

  def index
    laws = @current_user.laws.all
    render json: laws, status: :ok
  end

  def show
    render json: @law, status: :ok
  end

  def create
    law = @current_user.laws.new(law_params)

    if law.save
      render json: law, status: :created
    else
      render json: 'Failed to create law', status: :unprocessable_entity
    end
  end

  def destroy
    @law.destroy
    render json: 'Successfully deleted law', status: :ok
  end

  private

  def set_law
    @law = @current_user.laws.find(params[:id])
  end

  def law_params
    params.require(:law).permit(:law_name, :first_element, :second_element, :third_element, :fourth_element, :id_type)
  end
end
