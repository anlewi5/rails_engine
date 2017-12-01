class Api::V1::Merchants::RevenueController < ApplicationController

  def index
    render json: Merchant.format_all_merchants_revenue_for_date(params[:date])
  end

end
