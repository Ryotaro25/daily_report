FactoryBot.define do
  factory :micropost do
    content {"micropost test"}
    title {"title test"}
    start_time {"2020-01-01 12:00:00"}
    finish_time {"2000-01-01 22:00:00"}
    association :user
  end
end
