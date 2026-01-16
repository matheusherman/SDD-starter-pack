FactoryBot.define do
  factory :product do
    id { SecureRandom.uuid }
    title { Faker::Commerce.product_name }
    description { Faker::Lorem.paragraph(sentence_count: 2) }
    quantity { Faker::Number.between(from: 1, to: 100) }
    price { Faker::Commerce.price(range: 10..1000) }
  end
end
