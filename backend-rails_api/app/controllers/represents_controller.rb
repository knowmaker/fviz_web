class RepresentsController < ApplicationController
  before_action :set_represent, only: [:show, :update, :destroy]

  def index
    represents = Represent.all
    render json: { represents: represents }, status: :ok
  end

  def show
    render json: { represent: @represent }, status: :ok
  end

  def create
    represent = Represent.new(represent_params)

    if represent.save
      render json: { message: 'Successfully created represent', represent: represent }, status: :created
    else
      render json: { error: 'Failed to create represent', errors: represent.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @represent.update(represent_params)
      render json: { message: 'Successfully updated represent', represent: @represent }, status: :ok
    else
      render json: { error: 'Failed to update represent', errors: @represent.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @represent.destroy
    render json: { message: 'Successfully deleted represent' }, status: :ok
  end

  private

  def set_represent
    @represent = Represent.find(params[:id])
  end

  def represent_params
    params.require(:represent).permit(:title, :id_user, active_values: [])
  end

end
