class Api::V1::Merchants::SearchController < ApplicationController
  def index
    render json: Merchant.search_all(params)
  end

  def show
    render json: Merchant.search(params)
  end
end
