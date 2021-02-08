FactoryBot.define do
  factory :comment do
    content {"comment sample"}
    association :micropost
    user {micropost.user}
  end
end
