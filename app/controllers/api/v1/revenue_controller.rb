class Api::V1::RevenueController < ApplicationController

  def index
    render json: Merchant.single_merchant_revenue_response(params[:merchant_id])
  end

end
