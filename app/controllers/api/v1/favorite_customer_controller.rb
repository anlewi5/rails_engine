class Api::V1::FavoriteCustomerController < ApplicationController

  def index
    render json: Merchant.favorite_customer(params[:merchant_id])
  end

end
