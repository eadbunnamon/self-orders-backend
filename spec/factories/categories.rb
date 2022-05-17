FactoryBot.define do
  sequence(:category_name) { |n| "Category #{n}" }
  sequence(:category_name_en) { |n| "Category EN #{n}" }

  factory :category do
    name { generate(:category_name) }
    name { generate(:category_name_en) }
  end
end
