class InvoiceItem < ApplicationRecord
  belongs_to :invoice
  belongs_to :item

  # default_scope { order(:id) }

  def self.search(params)
    case
      when params["id"]
        InvoiceItem.find_by(id: params["id"].to_i)
      when params["quantity"]
        InvoiceItem.find_by(quantity: params["quantity"])
      when params["unit_price"]
        InvoiceItem.find_by(unit_price: (params["unit_price"].to_f * 100).round(2))
      when params["invoice_id"]
        InvoiceItem.find_by(invoice_id: params["invoice_id"].to_i)
      when params["item_id"]
        InvoiceItem.find_by(item_id: params["item_id"].to_i)
      when params["created_at"]
        InvoiceItem.find_by(created_at: params["created_at"].to_datetime)
      when params["updated_at"]
        InvoiceItem.find_by(updated_at: params["updated_at"].to_datetime)
      when params
        InvoiceItem.find_by(id: rand(1..InvoiceItem.count))
    end
  end

  def self.search_all(params)
    case
      when params["id"]
        InvoiceItem.where(id: params["id"].to_i)
      when params["quantity"]
        InvoiceItem.where(quantity: params["quantity"])
      when params["unit_price"]
        InvoiceItem.where(unit_price: (params["unit_price"].to_f * 100).round(2))
      when params["invoice_id"]
        InvoiceItem.where(invoice_id: params["invoice_id"].to_i)
      when params["item_id"]
        InvoiceItem.where(item_id: params["item_id"].to_i)
      when params["created_at"]
        InvoiceItem.where(created_at: params["created_at"].to_datetime)
      when params["updated_at"]
        InvoiceItem.where(updated_at: params["updated_at"].to_datetime)
    end
  end
end
