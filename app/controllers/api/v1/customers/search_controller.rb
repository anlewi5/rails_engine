class Api::V1::Customers::SearchController < ApplicationController
  def index
    render json: Customer.search_all(params)
  end

  def show
    render json: Customer.search(params)
  end
end
