class Transaction < ApplicationRecord
  belongs_to :invoice

  default_scope { order(:id) }

  scope :successful,      -> { where(result:"success") }
  scope :not_successful,  -> { where(result:"failed") }
end
