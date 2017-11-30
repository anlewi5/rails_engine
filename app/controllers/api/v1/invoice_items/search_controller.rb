class Api::V1::InvoiceItems::SearchController < ApplicationController
  def index
    render json: InvoiceItem.search_all(params)
  end

  def show
    render json: InvoiceItem.search(params)
  end

end
