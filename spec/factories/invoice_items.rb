FactoryBot.define do
  factory :invoice_item do
    sequence :quantity do
      Faker::Number.digit
    end
    sequence :unit_price  do
      Faker::Commerce.price
    end
    invoice
    item
  end
end
