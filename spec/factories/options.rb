FactoryBot.define do
  factory :option do
    name { 'Size' }
    name_en { 'Size!' }
    need_to_choose { false }
    maximum_choose { 1 }
    item
  end
end
