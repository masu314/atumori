FactoryBot.define do
  factory :post do
    title { "test" }
    work_id { "MO-XXXX-XXXX-XXXX" }
    author_id { "MA-XXXX-XXXX-XXXX" }
    text { "aaaa" }
    user
    category

    after(:create) do |post|
      create_list(:post_tag_relation, 1, post: post, tag: create(:tag))
      post.image.attach(io: File.open('spec/fixtures/other-image.png'), filename: 'other-image.png')
    end
  end
end
