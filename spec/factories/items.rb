FactoryBot.define do
  factory :item do
    sequence :name  do
      Faker::Coffee.blend_name
    end
    sequence :description  do
      Faker::Coffee.notes
    end
    sequence :unit_price do
      Faker::Commerce.price
    end
  end
end
