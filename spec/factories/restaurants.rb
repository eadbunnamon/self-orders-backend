FactoryBot.define do
  sequence(:restaurant_name) { |n| "Restaurant #{n}" }
  sequence(:restaurant_name_en) { |n| "Restaurant #{n}" }

  factory :restaurant do
    name { generate(:restaurant_name) }
    name_en { generate(:restaurant_name_en) }
    open_time { '09:00' }
    close_time { '21:00' }
    restaurant_type do
      rt = RestaurantType.find_by_restaurant_type('general')
      rt ? rt : FactoryBot.create(:restaurant_type, restaurant_type: 'general')
    end
  end
end
