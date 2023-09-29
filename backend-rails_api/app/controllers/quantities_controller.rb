# frozen_string_literal: true

# Контроллер для получения активных ФВ представления (верхний слой), просмотра слоев, а также для работы с ФВ админом
class QuantitiesController < ApplicationController
  include QuantitiesHelper
  before_action :authorize_request, only: %i[index create update destroy]
  before_action :set_quantity, only: %i[update destroy]

  def index
    # unless @current_user.role
    #   render json: {error: ['Только админ может загружать списко величин']}, status: :forbidden
    #   return
    # end

    @quantities = Quantity.joins(:gk, :lt).select('quantity.*, gk.*, lt.*')

    html_content = generate_html_table(@quantities)
    pdf = Grover.new(html_content, format: 'A4', encoding: 'UTF-8').to_pdf

    send_data pdf, filename: 'quantities_table.pdf', type: 'application/pdf', disposition: 'attachment'
  end

  def show
    @quantity = Quantity.joins(:gk, :lt).select('quantity.*, gk.*, lt.*').find(params[:id])
    render json: { data: @quantity }, status: :ok
  end

  def create
    # unless @current_user.role
    #   render json: {error: ['Только админ может создавать величины']}, status: :forbidden
    #   return
    # end

    quantity_params_result = quantity_params
    if quantity_params_result.key?(:error)
      render json: { error: [quantity_params_result[:error]] }, status: :unprocessable_entity
      return
    end

    quantity = Quantity.new(quantity_params_result)

    if quantity.save
      merged_quantity = Quantity.joins(:gk, :lt).select('quantity.*, gk.*, lt.*').find(quantity.id)
      render json: { data: merged_quantity }, status: :created
    else
      render json: { error: quantity.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    # unless @current_user.role
    #   render json: {error: ['Только админ может обновлять величины']}, status: :forbidden
    #   return
    # end

    if @quantity.update(quantity_params)
      @quantity.reload
      render json: { data: @quantity }, status: :ok
    else
      render json: { error: @quantity.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    # unless @current_user.role
    #   render json: {error: ['Только админ может удалять величины']}, status: :forbidden
    #   return
    # end

    @quantity.destroy
    head :ok
  end

  private

  def set_quantity
    @quantity = Quantity.find(params[:id])
  end

  def quantity_params
    quantity_params = params.require(:quantity)
                            .permit(:value_name, :symbol,
                                    :m_indicate_auto, :l_indicate_auto, :t_indicate_auto, :i_indicate_auto,
                                    :unit, :l_indicate, :t_indicate, :id_gk, :mlti_sign)

    lt = Lt.find_by(l_indicate: quantity_params[:l_indicate], t_indicate: quantity_params[:t_indicate])
    return { error: 'Такой ячейки не существует' } unless lt

    quantity_params[:id_lt] = lt.id_lt if lt

    quantity_params.delete(:l_indicate)
    quantity_params.delete(:t_indicate)

    quantity_params
  end
end
