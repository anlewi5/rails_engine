class Invoice < ApplicationRecord
  belongs_to :customer
  belongs_to :merchant
  has_many   :transactions
  has_many   :invoice_items
  has_many   :items, through: :invoice_items

  def self.search(params)

    case
    when params["id"]
        Invoice.find_by(id: params["id"].to_i)
      when params["status"]
        Invoice.find_by(status: params["status"])
      when params["customer_id"]
        Invoice.find_by(customer_id: params["customer_id"].to_i)
      when params["merchant_id"]
        Invoice.find_by(merchant_id: params["merchant_id"].to_i)
      when params["created_at"]
        Invoice.find_by(created_at: params["created_at"].to_datetime)
      when params["updated_at"]
        Invoice.find_by(updated_at: params["updated_at"].to_datetime)
      when params
        Invoice.find_by(id: rand(1..Invoice.count))
    end
  end

  def self.search_all(params)
    case
      when params["id"] || params["invoice_id"]
        Invoice.where(id: params["id"].to_i)
      when params["status"]
        Invoice.where(status: params["status"])
      when params["customer_id"]
        Invoice.where(customer_id: params["customer_id"].to_i)
      when params["merchant_id"]
        Invoice.where(merchant_id: params["merchant_id"].to_i)
      when params["created_at"]
        Invoice.where(created_at: params["created_at"].to_datetime)
      when params["updated_at"]
        Invoice.where(updated_at: params["updated_at"].to_datetime)
    end
  end
end
