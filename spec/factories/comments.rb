FactoryBot.define do
  factory :comment do
    content {"comment sample"}
    association :user
    association :micropost
  end
end
