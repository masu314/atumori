FactoryBot.define do
  factory :user do
    name { "test" }
    email {Faker::Internet.unique.email}
    password { "password" }
  end
end
