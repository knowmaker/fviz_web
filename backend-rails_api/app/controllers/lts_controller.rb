class LtsController < ApplicationController
  def get_quantity_by_cell_id
    @cell_id = params[:cellId]
    @quantities = Quantity.where(id_lt: @cell_id)
    render :json => @quantities.all
  end

  def index
  end


  def update
  end
end

