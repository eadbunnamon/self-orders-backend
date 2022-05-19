FactoryBot.define do
  sequence(:user_email) { |n| "email_#{n}@example.com" }

  factory :user do
    email { generate(:user_email) }
    password { "Asdqwe123!" }
    confirmed_at { Time.now }
  end
end
