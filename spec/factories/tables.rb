FactoryBot.define do
  sequence(:table_name) { |n| "Table #{n}" }

  factory :table do
    name { generate(:table_name) }
  end
end
