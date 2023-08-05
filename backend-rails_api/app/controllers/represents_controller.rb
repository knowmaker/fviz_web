# frozen_string_literal: true

class RepresentsController < ApplicationController
  before_action :authorize_request
  before_action :set_represent, only: %i[show update destroy]

  def index
    represents = @current_user.represents
    render json: represents, status: :ok
  end

  def show
    render json: @represent, status: :ok
  end

  def create
    represent = @current_user.represents.new(represent_params)

    if represent.save
      render json: represent, status: :created
    else
      render json: 'Failed to create represent', status: :unprocessable_entity
    end
  end

  def update
    if @represent.update(represent_params)
      render json: @represent, status: :ok
    else
      render json: 'Failed to update represent', status: :unprocessable_entity
    end
  end

  def destroy
    @represent.destroy
    render json: 'Successfully deleted represent', status: :ok
  end

  private

  def set_represent
    @represent = @current_user.represents.find(params[:id])
  end

  def represent_params
    params.require(:represent).permit(:title, active_values: [])
  end
end

