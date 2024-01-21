FactoryBot.define do
  factory :post do
    title { Faker::Lorem.unique.characters(number:5) }
    work_id { "MO-1111-1111-1111" }
    author_id { "MA-1111-1111-1111" }
    text { "aaaa" }
    user
    category

    after(:create) do |post|
      post.image.attach(io: File.open('spec/fixtures/other-image.png'), filename: 'other-image.png')
    end
  end
end
