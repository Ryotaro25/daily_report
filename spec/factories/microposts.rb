FactoryBot.define do
  factory :micropost do
    content {"micropost test"}
    title {"title test"}
    start_time {"2020-01-01 12:00:00"}
    finish_time {"2000-01-01 22:00:00"}
    created_at { 10.minutes.ago }
    association :user

    trait :yesterday do
      content { "yesterday" }
      created_at { 1.day.ago }
    end

    trait :day_before_yesterday do
      content { "day_before_yesterday" }
      created_at { 2.days.ago }
    end

    trait :now do
      content { "now!" }
      created_at { Time.zone.now }
    end
  end
end
