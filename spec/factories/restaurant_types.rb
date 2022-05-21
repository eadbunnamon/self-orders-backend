FactoryBot.define do
  sequence(:restaurant_type_type_name) { |n| "Restaurant Type #{n}" }
  sequence(:restaurant_type_type_name_en) { |n| "Restaurant Type EN #{n}" }

  factory :restaurant_type do
    type_name { generate(:restaurant_type_type_name) }
    type_name_en  { generate(:restaurant_type_type_name_en) }
    constant_type { 'general' }
    active { true }
  end
end
