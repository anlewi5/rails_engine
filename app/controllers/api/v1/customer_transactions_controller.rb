class Api::V1::CustomerTransactionsController < ApplicationController

  def index
    render json: Invoice.find(params[:customer_id]).transactions
  end
end
