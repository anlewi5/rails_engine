class Api::V1::BestDayController < ApplicationController

  def index
    render json: Item.best_day(params[:item_id])
  end

end
