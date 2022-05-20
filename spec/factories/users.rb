FactoryBot.define do
  sequence(:user_email) { |n| "email_#{n}@example.com" }

  factory :user do
    email { generate(:user_email) }
    password { "Asdqwe123!" }
    confirmed_at { Time.now }

    trait :super_admin do
      roles { [ Role.find_by_name('super_admin') ? Role.find_by_name('super_admin') : create(:role, name: 'super_admin') ] }
    end

    trait :admin do
      roles { [ Role.find_by_name('admin') ? Role.find_by_name('admin') : create(:role, name: 'admin') ] }
    end

    trait :restaurant_admin do
      roles { [ Role.find_by_name('restaurant_admin') ? Role.find_by_name('restaurant_admin') : create(:role, name: 'restaurant_admin') ] }
    end
  end
end
