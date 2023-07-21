class QuantitiesController < ApplicationController
  before_action :set_quantity, only: [:update, :destroy]

  def index
    @active_quantities = Quantity.where(id_value: Represent.select(:active_values).pluck(:active_values).flatten).left_joins(:lt).select("quantity.*, lt.*").order("quantity.id_lt")
    # добавить where user
    render json: @active_quantities.all
  end

  def show
    quantities = Quantity.where(id_lt: params[:id])
    if quantities.any?
      render json: quantities, status: :ok
    else
      render json: 'No quantities found for the given id_lt', status: :not_found
    end
  end

  def create
    quantity = Quantity.new(quantity_params)

    if quantity.save
      render json: quantity, status: :created
    else
      render json: 'Failed to create quantity', status: :unprocessable_entity
    end
  end

  def update
    if @quantity.update(quantity_params)
      render json: @quantity, status: :ok
    else
      render json: 'Failed to update quantity', status: :unprocessable_entity
    end
  end

  def destroy
    @quantity.destroy
    render json: 'Successfully deleted quantity', status: :ok
  end

  private

  def set_quantity
    @quantity = Quantity.find(params[:id])
  end

  def quantity_params
    params.require(:quantity).permit(:val_name, :symbol, :M_indicate, :L_indicate, :T_indicate, :I_indicate, :unit, :id_lt, :id_gk)
  end
end
