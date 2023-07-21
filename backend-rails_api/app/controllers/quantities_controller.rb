class QuantitiesController < ApplicationController
  before_action :set_quantity, only: [:update, :destroy]

  def index
    @active_quantities = Quantity.where(id_value: Represent.select(:active_values).pluck(:active_values).flatten).left_joins(:lt).select("quantity.*, lt.*").order("quantity.id_lt")
    # добавить where user
    render json: @active_quantities.all
  end

  def create
    quantity = Quantity.new(quantity_params)

    if quantity.save
      render json: { message: 'Successfully created quantity', quantity: quantity }, status: :created
    else
      render json: { error: 'Failed to create quantity', errors: quantity.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @quantity.update(quantity_params)
      render json: { message: 'Successfully updated quantity', quantity: @quantity }, status: :ok
    else
      render json: { error: 'Failed to update quantity', errors: @quantity.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @quantity.destroy
    render json: { message: 'Successfully deleted quantity' }, status: :ok
  end

  private

  def set_quantity
    @quantity = Quantity.find(params[:id])
  end

  def quantity_params
    params.require(:quantity).permit(:val_name, :symbol, :M_indicate, :L_indicate, :T_indicate, :I_indicate, :unit, :id_lt, :id_gk)
  end
end
