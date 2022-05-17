FactoryBot.define do
  sequence(:item_name) { |n| "Item #{n}" }
  sequence(:item_name_en) { |n| "Item EN #{n}" }

  factory :item do
    name { generate(:name) }
    name_en { generate(:name_en) }
    price { 259 }
  end
end
