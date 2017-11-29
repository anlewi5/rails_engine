class Api::V1::Transactions::SearchController < ApplicationController
  def index
    render json: Transaction.search_all(params)
  end

  def show
    render json: Transaction.search(params)
  end
end
