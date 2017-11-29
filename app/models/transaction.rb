class Transaction < ApplicationRecord
  belongs_to :invoice

  default_scope { order(:id) }

  scope :successful,      -> { where(result:"success") }
  scope :not_successful,  -> { where(result:"failed") }

  def self.search(params)
    case
      when params["id"]
        Transaction.find_by(id: params["id"].to_i)
      when params["invoice_id"]
        Transaction.find_by(invoice_id: params["invoice_id"])
      when params["credit_card_number"]
        Transaction.find_by(credit_card_number: params["credit_card_number"])
      when params["credit_card_expiration_date"]
        Transaction.find_by(credit_card_expiration_date: params["credit_card_expiration_date"])
      when params["result"]
        Transaction.find_by(result: params["result"])
      when params["created_at"]
        Transaction.find_by(created_at: params["created_at"].to_datetime)
      when params["updated_at"]
        Transaction.find_by(updated_at: params["updated_at"].to_datetime)
      when params
        Transaction.find_by(id: rand(1..Transaction.count))
    end
  end

  def self.search_all(params)
    case
      when params["id"]
        Transaction.where(id: params["id"].to_i)
      when params["invoice_id"]
        Transaction.where(invoice_id: params["invoice_id"])
      when params["credit_card_number"]
        Transaction.where(credit_card_number: params["credit_card_number"])
      when params["credit_card_expiration_date"]
        Transaction.where(credit_card_expiration_date: params["credit_card_expiration_date"])
      when params["result"]
        Transaction.where(result: params["result"])
      when params["created_at"]
        Transaction.where(created_at: params["created_at"].to_datetime)
      when params["updated_at"]
        Transaction.where(updated_at: params["updated_at"].to_datetime)
    end
  end
end
