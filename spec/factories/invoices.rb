FactoryBot.define do
  factory :invoice do
    sequence :status do
      Faker::Color.color_name
    end

    customer
    merchant
  end
end
