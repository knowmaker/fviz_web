class LtController < ApplicationController
  def index
    lts=Lt.order(:id_lt).all
    render json: { data: lts }, status: :ok
  end
end
