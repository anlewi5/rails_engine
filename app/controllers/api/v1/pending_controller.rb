class Api::V1::PendingController < ApplicationController
  def index
    render json: Merchant.pending_customers(params[:merchant_id])
  end
end
