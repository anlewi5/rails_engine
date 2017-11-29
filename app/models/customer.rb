class Customer < ApplicationRecord
  has_many :invoices

  default_scope { order(:id) }
  
  def self.search(params)
    case
      when params["id"]
        Customer.find_by(id: params["id"].to_i)
      when params["first_name"]
        Customer.find_by(first_name: params["first_name"])
      when params["last_name"]
        Customer.find_by(last_name: params["last_name"])
      when params["created_at"]
        Customer.find_by(created_at: params["created_at"].to_datetime)
      when params["updated_at"]
        Customer.find_by(updated_at: params["updated_at"].to_datetime)
      when params
        Customer.find_by(id: rand(1..Customer.count))
    end
  end

  def self.search_all(params)
    case
      when params["id"]
        Customer.where(id: params["id"].to_i)
      when params["first_name"]
        Customer.where(first_name: params["first_name"])
      when params["last_name"]
        Customer.where(last_name: params["last_name"])
      when params["created_at"]
        Customer.where(created_at: params["created_at"].to_datetime)
      when params["updated_at"]
        Customer.where(updated_at: params["updated_at"].to_datetime)
    end
  end
end
