class Api::V1::Items::SerachController < ApplicationController
  def index
    render json: Item.search_all(params)
  end

  def show
    render json: Item.search(params)
  end
end
