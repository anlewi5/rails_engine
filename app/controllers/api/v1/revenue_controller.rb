class Api::V1::RevenueController < ApplicationController

  def index
    render json: Merchant.revenue(params)
  end

end
