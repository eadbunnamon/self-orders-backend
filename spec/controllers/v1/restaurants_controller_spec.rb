require 'rails_helper'

RSpec.describe V1::RestaurantsController, type: :controller do
  before(:each) do
    token = AuthToken.token(restaurant_admin)
    request.headers['Authorization'] = token
  end

  let!(:admin) { FactoryBot.create(:user, :admin) }
  let!(:restaurant_admin) { FactoryBot.create(:user, :restaurant_admin) }

  let!(:general_restaurant) { FactoryBot.create(:restaurant_type, type_name: 'First', type_name_en: 'First EN', constant_type: 'general') }
  let!(:buffet_restaurant) { FactoryBot.create(:restaurant_type, type_name: 'Second', type_name_en: 'Second EN', constant_type: 'buffet') }

  context 'GET index' do
    it 'renders all restaurant types' do
      restaurant_1 = FactoryBot.create(:restaurant, restaurant_type: general_restaurant, users: [restaurant_admin])
      restaurant_2 = FactoryBot.create(:restaurant, restaurant_type: general_restaurant, users: [admin])

      get :index
      expect(response).to have_http_status(:ok)
      expect(assigns[:restaurants]).to include(restaurant_1)
      expect(assigns(:restaurants)).not_to include(restaurant_2)
    end
  end

  context 'POST create' do
    it 'create a new restaurant' do
      expect {
        post :create, params: {
          restaurant: {
            name: 'ETNEE',
            name_en: 'ETNEEN',
            open_time: '08:00',
            close_time: '19:00',
            day_off_description: '16th and 1st of each month',
            day_off_description_en: '16th and 1st of each month en',
            restaurant_type_id: general_restaurant.id
          }
        }
      }.to change(Restaurant, :count).by(1)

      restaurant = Restaurant.order(created_at: :asc).last
      expect(restaurant.name).to eq('ETNEE')
      expect(restaurant.name_en).to eq('ETNEEN')
      expect(restaurant.open_time).to eq('08:00')
      expect(restaurant.close_time).to eq('19:00')
      expect(restaurant.day_off_description).to eq('16th and 1st of each month')
      expect(restaurant.day_off_description_en).to eq('16th and 1st of each month en')
      expect(restaurant.restaurant_type_id).to eq(general_restaurant.id)
    end
  end
end
