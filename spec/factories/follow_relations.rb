FactoryBot.define do
  factory :follow_relation do
    association :follower, factory: :user
    association :followed, factory: :user
  end
end
