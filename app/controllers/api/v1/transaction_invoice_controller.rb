class Api::V1::TransactionInvoiceController < ApplicationController
  def index
    render json: Transaction.find(params[:transaction_id]).invoice
  end
end
