class Api::V1::FavoriteMerchantController < ApplicationController

  def index
    render json: Customer.favorite_merchant(params[:customer_id])
  end

end
