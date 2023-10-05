# frozen_string_literal: true

# Контроллер для работы с представлениями ФВ
class RepresentsController < ApplicationController
  before_action :authorize_request, except: %i[represent_view_index]
  before_action -> { authorize_request(check_current_user: false) }, only: %i[represent_view_index]
  before_action :set_represent, only: %i[update destroy represent_view_show]

  def index
    represents = @current_user.represents.select('represents.id_repr, represents.title').order(:id_repr).all
    render json: { data: represents }, status: :ok
  end

  def show
    @represent = @current_user.represents.select('represents.id_repr, represents.title').find_by(id_repr: params[:id])
    if @represent
      render json: { data: @represent }, status: :ok
    else
      render json: { error: ['Представление не найдено'] }, status: :not_found
    end
  end

  def create
    represent = @current_user.represents.new(represent_params)

    if represent.save
      render json: { data: represent }, status: :created
    else
      render json: { error: represent.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @represent
      if @represent.update(represent_params)
        render json: { data: @represent }, status: :ok
      else
        render json: { error: @represent.errors.full_messages }, status: :unprocessable_entity
      end
    else
      render json: { error: ['Представление не найдено'] }, status: :not_found
    end
  end

  def destroy
    if @represent
      @represent.destroy
      head :ok
    else
      render json: { error: ['Представление не найдено'] }, status: :not_found
    end
  end

  def represent_view_index
    represent_id = @current_user ? @current_user.active_repr : 1
    quantity_ids = Represent.where(id_repr: represent_id).pluck(:active_quantities).flatten
    active_quantities = Quantity.where(id_value: quantity_ids).order(:id_lt).all

    json_output = {
      id_repr: represent_id,
      title: Represent.where(id_repr: represent_id).select('title'),
      active_quantities:
    }
    render json: { data: json_output }, status: :ok
  end

  def represent_view_show
    if @represent
      @current_user.update(active_repr: @represent.id_repr)
      quantity_ids = @represent.active_quantities.flatten
      active_quantities = Quantity.where(id_value: quantity_ids).order(:id_lt).all

      json_output = {
        id_repr: @represent.id_repr,
        title: @represent.title,
        active_quantities:
      }

      render json: { data: json_output }, status: :ok
    else
      render json: { error: ['Представление не найдено'] }, status: :not_found
    end
  end

  private

  def set_represent
    @represent = @current_user.represents.find_by(id_repr: params[:id])
  end

  def represent_params
    params.require(:represent).permit(:title, active_quantities: [])
  end
end
