class Item < ApplicationRecord
  belongs_to :merchant
  has_many   :invoice_items
  has_many   :invoices, through: :invoice_items

  default_scope { order(:id) }

  def self.search(params)
    case
      when params["id"]
        Item.find_by(id: params["id"].to_i)
      when params["name"]
        Item.find_by(name: params["name"])
      when params["description"]
        Item.find_by(description: params["description"])
      when params["unit_price"]
        Item.find_by(unit_price: (params["unit_price"].to_f * 100).round(2))
      when params["merchant_id"]
        Item.find_by(merchant_id: params["merchant_id"].to_i)
      when params["created_at"]
        Item.find_by(created_at: params["created_at"].to_datetime)
      when params["updated_at"]
        Item.find_by(updated_at: params["updated_at"].to_datetime)
      when params
        Item.find_by(id: rand(1..Item.count))
    end
  end

  def self.search_all(params)
    case
      when params["id"]
        Item.where(id: params["id"].to_i)
      when params["name"]
        Item.where(name: params["name"])
      when params["description"]
        Item.where(description: params["description"])
      when params["unit_price"]
        Item.where(unit_price: (params["unit_price"].to_f * 100).round(2))
      when params["merchant_id"]
        Item.where(merchant_id: params["merchant_id"].to_i)
      when params["created_at"]
        Item.where(created_at: params["created_at"].to_datetime)
      when params["updated_at"]
        Item.where(updated_at: params["updated_at"].to_datetime)
    end
  end

  def self.most_items(quantity)
    select('items.*, sum(invoice_items.quantity) as total')
    .joins(invoice_items: [invoice: :transactions])
    .merge(Transaction.unscoped.successful)
    .group('items.id')
    .order('total DESC')
    .limit(quantity)
  end

  def self.most_revenue(quantity)
    select('items.*, sum(invoice_items.quantity invoice_items.unit_price) as total')
    .joins(invoice_items: [invoice: :transactions])
    .merge(Transaction.unscoped.successful)
    .group('items.id')
    .order('total DESC')
    .limit(quantity)
  end

  def self.best_day(item_id)
      find(item_id)
      .invoices
      .where(invoice_items: { item_id: item_id })
      .joins(invoice_items: [invoice: :transactions])
      .merge(Transaction.unscoped.successful)
      .order("invoice_items.quantity DESC")
      .first
  end
end
