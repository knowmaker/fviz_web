# frozen_string_literal: true

# Контроллер для работы с закономерностями
class LawsController < ApplicationController
  before_action :authorize_request
  before_action :set_law, only: %i[show update destroy]

  def index
    laws = @current_user.laws.joins(:law_type).select(Law.column_names - ['combination'], 'laws_type.type_name').all
    render json: laws, status: :ok
  end

  def show
    @law = @current_user.laws
                        .joins(
                          'LEFT JOIN quantity AS first_element_quantities ON laws.first_element = first_element_quantities.id_value',
                          'LEFT JOIN quantity AS second_element_quantities ON laws.second_element = second_element_quantities.id_value',
                          'LEFT JOIN quantity AS third_element_quantities ON laws.third_element = third_element_quantities.id_value',
                          'LEFT JOIN quantity AS fourth_element_quantities ON laws.fourth_element = fourth_element_quantities.id_value'
                        )
                        .select(
                          Law.column_names - ['combination'],
                          'CONCAT_WS(\' * \', first_element_quantities.value_name, second_element_quantities.value_name, third_element_quantities.value_name, fourth_element_quantities.value_name) AS text_formula',
                          'CONCAT_WS(\' * \', first_element_quantities.symbol, second_element_quantities.symbol, third_element_quantities.symbol, fourth_element_quantities.symbol) AS formula'
                        ).find(params[:id])

    render json: @law, status: :ok
  end

  def create
    combination = [params[:law][:first_element], params[:law][:first_element], params[:law][:first_element],
                   params[:law][:first_element]]
    law = Law.find_by(combination: combination.sort, id_user: @current_user.id_user)
    render json: 'Law already exists', status: :unprocessable_entity and return if law

    law = @current_user.laws.new(law_params)

    if law.save
      render json: law, status: :created
    else
      render json: 'Failed to create law', status: :unprocessable_entity
    end
  end

  def update
    if @law.update(law_params)
      render json: @law, status: :ok
    else
      render json: 'Failed to update law', status: :unprocessable_entity
    end
  end

  def destroy
    @law.destroy
    render json: 'Successfully deleted law', status: :ok
  end

  private

  def set_law
    @law = @current_user.laws.find(params[:id])
  end

  def law_params
    params.require(:law).permit(:law_name, :first_element, :second_element, :third_element, :fourth_element, :id_type)
  end
end
