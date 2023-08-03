# frozen_string_literal: true

class LawsController < ApplicationController
  before_action :set_law, only: %i[show update destroy]

  def index
    laws = Law.all
    render json: laws, status: :ok
  end

  def show
    render json: @law, status: :ok
  end

  def create
    law = Law.new(law_params)

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
    @law = Law.find(params[:id])
  end

  def law_params
    params.require(:law).permit(:law_name, :first_element, :second_element, :third_element, :fourth_element, :id_user,
                                :id_type)
  end
end
