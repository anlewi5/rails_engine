class InvoiceItem < ApplicationRecord
  belongs_to :invoice
  belongs_to :item

  default_scope { order(:id) }
end
