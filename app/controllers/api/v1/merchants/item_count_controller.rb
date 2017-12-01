class Api::V1::Merchants::ItemCountController < ApplicationController
  def index
    render json: Merchant.merchants_selling_most_items(params[:quantity])
  end
end
