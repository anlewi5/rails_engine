class Api::V1::InvoiceController < ApplicationController

  def index
    render json: Invoice.all
  end

  def show
    render json: Invoice.find(param[:id])
  end
end
