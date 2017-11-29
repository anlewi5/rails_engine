FactoryBot.define do
  factory :invoice do
    sequence :status do
      Faker::Color.color_name
    end
  end
end
