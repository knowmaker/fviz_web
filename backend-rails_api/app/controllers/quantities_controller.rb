# frozen_string_literal: true

# Контроллер для получения активных ФВ представления (верхний слой), просмотра слоев, а также для работы с ФВ админом
class QuantitiesController < ApplicationController
  include QuantitiesHelper
  before_action :authorize_request, only: %i[index create update destroy]
  before_action :set_quantity, only: %i[update destroy]

  # Метод для получения перечня физических величин
  # Сохраняется в виде PDF файла
  def index
    # unless @current_user.role
    #   render json: {error: [I18n.t('errors.quantities.admin_forbidden')]}, status: :forbidden
    #   return
    # end

    quantities = Quantity.joins(:gk, :lt).select('quantity.*, gk.*, lt.*')

    html_content = generate_html_table(quantities)
    pdf = Grover.new(html_content, format: 'A4', encoding: 'UTF-8').to_pdf

    send_data pdf, filename: 'quantities_table.pdf', type: 'application/pdf', disposition: 'attachment'
  end

  # Метод для получения одной величины. Параметр - id величины
  def show
    @quantity = Quantity.joins(:gk, :lt).select('quantity.*, gk.*, lt.*').find_by(id_value: params[:id])
    if @quantity
      render json: { data: @quantity }, status: :ok
    else
      render json: { error: [I18n.t('errors.quantities.not_found')] }, status: :not_found
    end
  end

  # Метод для создания новой величины
  def create
    # unless @current_user.role
    #   render json: {error: [I18n.t('errors.quantities.admin_forbidden')]}, status: :forbidden
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

  # Метод для обновления параметров величины. Параметр - id величины
  def update
    # unless @current_user.role
    #   render json: {error: [I18n.t('errors.quantities.admin_forbidden')]}, status: :forbidden
    #   return
    # end

    if @quantity
      quantity_params_result = quantity_params
      if quantity_params_result.key?(:error)
        render json: { error: [quantity_params_result[:error]] }, status: :unprocessable_entity
        return
      end

      if @quantity.update(quantity_params_result)
        @quantity.reload
        render json: { data: @quantity }, status: :ok
      else
        render json: { error: @quantity.errors.full_messages }, status: :unprocessable_entity
      end
    else
      render json: { error: [I18n.t('errors.quantities.not_found')] }, status: :not_found
    end
  end

  # Метод для удаления величины. Параметр - id величины
  def destroy
    # unless @current_user.role
    #   render json: {error: [I18n.t('errors.quantities.admin_forbidden')]}, status: :forbidden
    #   return
    # end

    if @quantity
      @quantity.destroy
      head :ok
    else
      render json: { error: [I18n.t('errors.quantities.not_found')] }, status: :not_found
    end
  end

  # Метод для получения перечня физических величин, расположенных в одной ячейке
  def lt_values
    if Lt.find_by(id_lt: params[:id])
      quantities = Quantity.where(id_lt: params[:id])
      if quantities.any?
        render json: { data: quantities }, status: :ok
      else
        render json: { data: [] }, status: :ok
      end
    else
      render json: { error: [I18n.t('errors.quantities.cell_not_found')] }, status: :not_found
    end
  end

  private

  def set_quantity
    @quantity = Quantity.find_by(id_value: params[:id])
  end

  def quantity_params
    quantity_params = params.require(:quantity)
                            .permit(:value_name, :symbol,
                                    :m_indicate_auto, :l_indicate_auto, :t_indicate_auto, :i_indicate_auto,
                                    :unit, :l_indicate, :t_indicate, :id_gk)

    lt = Lt.find_by(l_indicate: quantity_params[:l_indicate], t_indicate: quantity_params[:t_indicate])
    return { error: I18n.t('errors.quantities.not_found') } unless lt

    quantity_params[:id_lt] = lt.id_lt if lt

    quantity_params.delete(:l_indicate)
    quantity_params.delete(:t_indicate)
    p quantity_params
    quantity_params
  end
end
