class LawTypesController < ApplicationController
  before_action :set_law_type, only: [:update, :destroy]

  def index
    law_types = LawType.all
    render json: law_types, status: :ok
  end

  def create
    law_type = LawType.new(law_type_params)

    if law_type.save
      render json: law_type, status: :created
    else
      render json: 'Failed to create law_type', status: :unprocessable_entity
    end
  end

  def update
    if @law_type.update(law_type_params)
      render json: @law_type, status: :ok
    else
      render json: 'Failed to update law_type', status: :unprocessable_entity
    end
  end

  def destroy
    @law_type.destroy
    render json: 'Successfully deleted law_type', status: :ok
  end

  private

  def set_law_type
    @law_type = LawType.find(params[:id])
  end

  def law_type_params # and update_params too
    params.require(:law_type).permit(:type_name)
  end
end

