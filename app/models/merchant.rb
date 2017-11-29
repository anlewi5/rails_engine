class Merchant < ApplicationRecord
  has_many :invoices
  has_many :items

  def self.search(params)
    case
      when params["id"]
        Merchant.find_by(id: params["id"].to_i)
      when params["name"]
        Merchant.find_by(name: params["name"])
      when params["created_at"]
        Merchant.find_by(created_at: params["created_at"].to_datetime)
      when params["updated_at"]
        Merchant.find_by(updated_at: params["updated_at"].to_datetime)
      when params
        Merchant.find_by(id: rand(1..Merchant.count))
    end
  end

  def self.search_all(params)
    case
      when params["id"]
        Merchant.where(id: params["id"].to_i)
      when params["name"]
        Merchant.where(name: params["name"])
      when params["created_at"]
        Merchant.where(created_at: params["created_at"].to_datetime)
      when params["updated_at"]
        Merchant.where(updated_at: params["updated_at"].to_datetime)
    end
  end
end
