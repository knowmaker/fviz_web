# frozen_string_literal: true

# Контроллер для получения активных ФВ представления (верхний слой), просмотра слоев, а также для работы с ФВ админом
class QuantitiesController < ApplicationController
  before_action :authorize_request, except: %i[index show]
  before_action :set_quantity, only: %i[update destroy]

  def index
    if @current_user
      represent_ids = @current_user.represents.first
    else
      represent_ids = 1 # ID представления, которое нужно использовать, когда нет текущего пользователя
    end
    quantity_ids = Represent.where(id_repr: represent_ids).pluck(:active_values).flatten
    active_quantities = Quantity.where(id_value: quantity_ids)
                                .left_joins(:lt)
                                .select('quantity.id_value,
                                 quantity.val_name,
                                 quantity.symbol,
                                 quantity.unit,
                                 quantity.id_lt,
                                 quantity.id_gk,
                                 quantity.mlti_sign,
                                 lt.lt_sign')
                                .order('quantity.id_lt')
    render json: active_quantities.all
  end

  def show
    quantities = Quantity.where(id_lt: params[:id]).where.not(id_value: Represent.pluck(:active_values).flatten)
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

  # and update_params too
  def quantity_params
    params.require(:quantity).permit(:val_name, :symbol, :M_indicate, :L_indicate, :T_indicate, :I_indicate, :unit,
                                     :id_lt, :id_gk)
  end
end
