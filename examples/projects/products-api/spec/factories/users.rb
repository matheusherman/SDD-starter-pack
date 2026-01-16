FactoryBot.define do
  factory :user do
    id { SecureRandom.uuid }
    sequence(:email) { |n| "user#{n}@example.com" }
    name { Faker::Name.name }
    role { "user" }
    password { "SecurePassword123" }
    password_confirmation { "SecurePassword123" }
  end

  factory :admin, class: User do
    id { SecureRandom.uuid }
    sequence(:email) { |n| "admin#{n}@example.com" }
    name { Faker::Name.name }
    role { "admin" }
    password { "SecurePassword123" }
    password_confirmation { "SecurePassword123" }
  end
end
