FactoryBot.define do
  sequence(:type_name) { |n| "Restaurant Type #{n}" }
  sequence(:type_name_en) { |n| "Restaurant Type EN #{n}" }

  factory :restaurant_type do
    type_name { generate(:type_name) }
    type_name_en  { generate(:type_name_en) }
  end
end
