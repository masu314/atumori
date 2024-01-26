FactoryBot.define do
  factory :user do
    name { Faker::Internet.unique.user_name(specifier: 1..20) }
    email { Faker::Internet.unique.email }
    password { "password" }
  end
end
