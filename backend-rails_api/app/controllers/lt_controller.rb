# frozen_string_literal: true

# Контроллер для работы со значениями ячеек (показ)
class LtController < ApplicationController
  # Метод для получения перечня ячеек системы
  def index
    lts = Lt.order(:id_lt).all
    render json: { data: lts }, status: :ok
  end
end
