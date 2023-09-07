# frozen_string_literal: true

# Контроллер для получения активных ФВ представления (верхний слой), просмотра слоев, а также для работы с ФВ админом
class QuantitiesController < ApplicationController
  include QuantitiesHelper
  # before_action :authorize_request
  before_action :set_quantity, only: %i[show update]

  def index
    # unless @current_user.role
    #   render json: {error: ['Only admins can see all quantities list']}, status: :unauthorized
    #   return
    # end

    @quantities = Quantity.joins(:gk, :lt).select('quantity.*, gk.*, lt.*')

    html_content = generate_html_table(@quantities)
    send_data html_content, filename: 'quantities_table.html', type: 'text/html', disposition: 'attachment'
  end

  def show
    # unless @current_user.role
    #   render json: {error: ['Only admins can see to quantity']}, status: :unauthorized
    #   return
    # end

    render json: {data: @quantity}, status: :ok
  end

  def create
    # unless @current_user.role
    #   render json: {error: ['Only admins can create quantities']}, status: :unauthorized
    #   return
    # end

    quantity = Quantity.new(quantity_params)

    if quantity.save
      merged_quantity = Quantity.joins(:gk, :lt).select('quantity.*, gk.*, lt.*').find(quantity.id)
      render json: {data: merged_quantity}, status: :created
    else
      render json: {error: @current_user.errors.full_messages}, status: :unprocessable_entity
    end
  end

  def update
    # unless @current_user.role
    #   render json: {error: ['Only admins can update quantities']}, status: :unauthorized
    #   return
    # end

    if @quantity.update(quantity_params)
      @quantity.reload
      render json: {data: @quantity}, status: :ok
    else
      render json: {error: @current_user.errors.full_messages}, status: :unprocessable_entity
    end
  end

  def destroy
    # unless @current_user.role
    #   render json: {error: ['Only admins can delete quantities']}, status: :unauthorized
    #   return
    # end
    @quantity = Quantity.find(params[:id])

    @quantity.destroy
    head :ok
  end

  private

  def set_quantity
    @quantity = Quantity.joins(:gk, :lt).select('quantity.*, gk.*, lt.*').find(params[:id])
  end

  def quantity_params
    quantity_params = params.require(:quantity)
                            .permit(:value_name, :symbol,
                                    :m_indicate_auto, :l_indicate_auto, :t_indicate_auto, :i_indicate_auto,
                                    :unit, :l_indicate, :t_indicate, :id_gk)

    lt = Lt.find_by(l_indicate: quantity_params[:l_indicate], t_indicate: quantity_params[:t_indicate])

    quantity_params[:id_lt] = lt.id_lt if lt

    quantity_params.delete(:l_indicate)
    quantity_params.delete(:t_indicate)

    # if Quantity.exists?(id_lt: quantity_params[:id_lt], id_gk: quantity_params[:id_gk])
    #   render json: { error: ['Combination of id_lt and id_gk already exists'] }, status: :unprocessable_entity
    #   return
    # end

    quantity_params
  end
end
