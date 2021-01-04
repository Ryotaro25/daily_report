# メインのサンプルユーザーを1人作成する
User.create!(name:  "Example User",
             email: "example@railstutorial.org",
             password:              "foobar",
             password_confirmation: "foobar",
             admin: true)

# 追加のユーザーをまとめて生成する
99.times do |n|
  name  = Faker::Name.name
  email = "example-#{n+1}@railstutorial.org"
  password = "password"
  User.create!(name:  name,
               email: email,
               password:              password,
               password_confirmation: password)
end

users = User.order(:created_at).take(6)
50.times do
  content = Faker::Lorem.sentence(word_count: 10)
  title = Faker::Lorem.sentence(word_count: 5)
  start_time = Faker::Time.between(from: DateTime.now - 1, to: DateTime.now)
  finish_time = Faker::Time.between(from: DateTime.now - 1, to: DateTime.now)
  users.each { |user| user.microposts.create!(content: content, title: title, start_time: start_time, finish_time: finish_time) }
end