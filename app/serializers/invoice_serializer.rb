class InvoiceSerializer < ActiveModel::Serializer
  attributes :id, :status, :customer_id, :merchant_id, :created_at
end
