FactoryBot.define do
  factory :comment do
    ser { nil }
    micropost { nil }
    content { "MyString" }
  end
end
