class RepresentsController < ApplicationController
  def index
    @active_quantities = Quantity.where(id_value: Represent.select(:active_values).pluck(:active_values).flatten).left_joins(:lt).select("quantity.*, lt.*").order("quantity.id_lt")
    #добавить where user
    render :json => @active_quantities.all
  end

  def create
  end

  def update
  end

  def destroy
  end
end
