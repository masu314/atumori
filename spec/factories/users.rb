FactoryBot.define do
  factory :user do
    name { "taro" }
    email {Faker::Internet.unique.email}
    password { "password" }
  end
end
