class Api::V1::Invoices::SearchController < ApplicationController
  def index
    render json: Invoice.search_all(params)
  end

  def show
    render json: Invoice.search(params)
  end
end
