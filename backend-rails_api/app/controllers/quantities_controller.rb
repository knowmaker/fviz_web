# frozen_string_literal: true

# Контроллер для получения активных ФВ представления (верхний слой), просмотра слоев, а также для работы с ФВ админом
class QuantitiesController < ApplicationController
  before_action :authorize_request, except: %i[index show]
  before_action :set_quantity, only: %i[update destroy]

  def index
    represent_ids = if @current_user
                      @current_user.represents.first
                    else
                      1 # ID представления, которое нужно использовать, когда нет текущего пользователя
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
    unless @current_user.role
      render json: 'Only admins can create quantities', status: :unauthorized
      return
    end

    quantity = Quantity.new(quantity_params)

    if quantity.save
      render json: quantity, status: :created
    else
      render json: 'Failed to create quantity', status: :unprocessable_entity
    end
  end

  def update
    unless @current_user.role
      render json: 'Only admins can update quantities', status: :unauthorized
      return
    end

    if @quantity.update(quantity_params)
      render json: @quantity, status: :ok
    else
      render json: 'Failed to update quantity', status: :unprocessable_entity
    end
  end

  def destroy
    unless @current_user.role
      render json: 'Only admins can delete quantities', status: :unauthorized
      return
    end

    @quantity.destroy
    render json: 'Successfully deleted quantity', status: :ok
  end

  private

  def set_quantity
    @quantity = Quantity.find(params[:id])
  end

  def quantity_params
    quantity_params = params.require(:quantity).permit(:val_name, :symbol,
                                                       :M_indicate, :L_indicate, :T_indicate, :I_indicate,
                                                       :unit, :l_indicate, :t_indicate, :g_indicate, :k_indicate)

    lt = Lt.find_by(l_indicate: quantity_params[:l_indicate], t_indicate: quantity_params[:t_indicate])
    gk = Gk.find_by(g_indicate: quantity_params[:g_indicate], k_indicate: quantity_params[:k_indicate])

    quantity_params[:id_lt] = lt.id_lt if lt
    quantity_params[:id_gk] = gk.id_gk if gk

    quantity_params
  end
end
