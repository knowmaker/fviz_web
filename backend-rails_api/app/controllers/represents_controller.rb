class RepresentsController < ApplicationController
  before_action :set_represent, only: [:show, :update, :destroy]

  def index
    represents = Represent.all
    render json: represents, status: :ok
  end

  def show
    render json: @represent, status: :ok
  end

  def create
    represent = Represent.new(represent_params)

    if represent.save
      render json: represent, status: :created
    else
      render json: 'Failed to create represent', status: :unprocessable_entity
    end
  end

  def update
    if @represent.update(represent_update_params)
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
    @represent = Represent.find(params[:id])
  end

  def represent_params
    params.require(:represent).permit(:title, :id_user, active_values: [])
  end

  def represent_update_params
    params.require(:represent).permit(:title, active_values: [])
  end

end
