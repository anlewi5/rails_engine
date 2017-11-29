class Api::V1::Merchants::SearchController < ApplicationController
  def index
    render json: Merchant.all
  end

  def show
    if params["id"]
      render json: Merchant.find(params["id"])
    elsif params["name"]
      render json: Merchant.find_by(name: params["name"])
    elsif params["created_at"]
      render json: Merchant.find_by(created_at: params["created_at"])
    elsif params["updated_at"]
      render json: Merchant.find_by(updated_at: params["updated_at"])
    end
  end
end
