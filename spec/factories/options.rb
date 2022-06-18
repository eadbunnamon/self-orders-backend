FactoryBot.define do
  factory :option do
    size { 'Normal' }
    price { 200 }
    is_default { true }

    item
  end
end
