# frozen_string_literal: true

# Контроллер для работы с представлениями ФВ
class RepresentsController < ApplicationController
  before_action :authorize_request, except: %i[represent_view_index lt_values]
  before_action :set_represent, only: %i[update destroy represent_view_show]

  def index
    represents = @current_user.represents.select('represents.id_repr, represents.title')
    render json: represents, status: :ok
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

  def represent_view_index
    represent_id = @current_user ? @current_user.represents.first : 1
    quantity_ids = Represent.where(id_repr: represent_id).pluck(:active_quantities).flatten
    active_quantities = Quantity.where(id_value: quantity_ids)
                                .left_joins(:lt)
                                .select('quantity.id_value, quantity.value_name, quantity.symbol, quantity.unit,
                                 quantity.id_lt, quantity.id_gk,
                                 quantity.mlti_sign, lt.lt_sign')
                                .order('quantity.id_lt')
    render json: active_quantities.all
  end

  def represent_view_show
    quantity_ids = @represent.active_quantities.flatten
    active_quantities = Quantity.where(id_value: quantity_ids)
                                .left_joins(:lt)
                                .select('quantity.id_value, quantity.value_name, quantity.symbol, quantity.unit,
                                 quantity.id_lt, quantity.id_gk,
                                 quantity.mlti_sign, lt.lt_sign')
                                .order('quantity.id_lt').all
    json_output = {
      represent_title: @represent.title,
      active_quantities: active_quantities.map do |quantity|
        {
          id_value: quantity.id_value,
          value_name: quantity.value_name,
          symbol: quantity.symbol,
          unit: quantity.unit,
          id_lt: quantity.id_lt,
          id_gk: quantity.id_gk,
          mlti_sign: quantity.mlti_sign,
          lt_sign: quantity.lt_sign
        }
      end
    }

    render json: json_output
  end

  def lt_values
    quantities = Quantity.where(id_lt: params[:id])
    if quantities.any?
      render json: quantities, status: :ok
    else
      render json: 'No quantities found for the given id_lt', status: :not_found
    end
  end

  private

  def set_represent
    @represent = @current_user.represents.find(params[:id])
  end

  def represent_params
    params.require(:represent).permit(:title, active_quantities: [])
  end
end
