FactoryBot.define do
  sequence(:item_name) { |n| "Item #{n}" }
  sequence(:item_name_en) { |n| "Item EN #{n}" }

  factory :item do
    name { generate(:item_name) }
    name_en { generate(:item_name_en) }
    price { 60 }

    category
  end
end
