FactoryBot.define do
  sequence(:staff_name) { |n| "Staff #{n}" }
  sequence(:staff_phone_number) { |n| "0123456789#{n}" }

  factory :staff do
    name { generate(:staff_name) }
    name { generate(:staff_phone_number) }
  end
end
