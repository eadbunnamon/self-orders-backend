require 'rails_helper'

RSpec.describe V1::RestaurantsController, type: :controller do
  before(:each) do
    token = AuthToken.token(restaurant_admin)
    request.headers['Authorization'] = token
  end

  let!(:restaurant_admin) { FactoryBot.create(:user, :restaurant_admin) }
  let!(:restaurant_admin_2) { FactoryBot.create(:user, :restaurant_admin) }

  let!(:general_restaurant) { FactoryBot.create(:restaurant_type, type_name: 'First', type_name_en: 'First EN', constant_type: 'general') }
  let!(:buffet_restaurant) { FactoryBot.create(:restaurant_type, type_name: 'Second', type_name_en: 'Second EN', constant_type: 'buffet') }

  context 'GET index' do
    it 'renders all restaurants' do
      restaurant_1 = FactoryBot.create(:restaurant, restaurant_type: general_restaurant, users: [restaurant_admin])
      restaurant_2 = FactoryBot.create(:restaurant, restaurant_type: general_restaurant, users: [restaurant_admin_2])

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

  context 'PUT update' do
    it 'update a restaurant' do
      restaurant = FactoryBot.create(:restaurant, restaurant_type: general_restaurant, users: [restaurant_admin])

      expect {
        put :update, params: {
          id: restaurant.id,
          restaurant: {
            name: 'ETNEE-1',
            name_en: 'ETNEEN-1',
            open_time: '07:00',
            close_time: '18:00',
            day_off_description: '17th and 2nd of each month',
            day_off_description_en: '17th and 2nd of each month en',
            restaurant_type_id: general_restaurant.id
          }
        }
      }.to change(Restaurant, :count).by(0)

      restaurant.reload
      expect(restaurant.name).to eq('ETNEE-1')
      expect(restaurant.name_en).to eq('ETNEEN-1')
      expect(restaurant.open_time).to eq('07:00')
      expect(restaurant.close_time).to eq('18:00')
      expect(restaurant.day_off_description).to eq('17th and 2nd of each month')
      expect(restaurant.day_off_description_en).to eq('17th and 2nd of each month en')
      expect(restaurant.restaurant_type_id).to eq(general_restaurant.id)
    end
  end

  context 'GET show' do
    it 'get a restaurant information' do
      restaurant = FactoryBot.create(:restaurant,
        name: 'ETNEE',
        name_en: 'ERNEEN',
        open_time: '07:00',
        close_time: '18:00',
        day_off_description: '16th and 1st of each month',
        day_off_description_en: '16th and 1st of each month en',
        restaurant_type: general_restaurant,
        users: [restaurant_admin])

      get :show, params: { id: restaurant.id }

      expect(response).to have_http_status(:success)
      response_body = JSON.parse(response.body).deep_symbolize_keys

      expect(response_body[:name]).to eq('ETNEE')
      expect(response_body[:name_en]).to eq('ERNEEN')
      expect(response_body[:open_time]).to eq('07:00')
      expect(response_body[:close_time]).to eq('18:00')
      expect(response_body[:day_off_description]).to eq('16th and 1st of each month')
      expect(response_body[:day_off_description_en]).to eq('16th and 1st of each month en')
      expect(response_body[:restaurant_type_id]).to eq(general_restaurant.id)
    end
  end

  context 'DELETE destroy' do
    it 'soft-delete a restaurant' do
      restaurant = FactoryBot.create(:restaurant, restaurant_type: general_restaurant, users: [restaurant_admin])

      expect{
        delete :destroy, params: { id: restaurant.id }
      }.to change(Restaurant, :count).by(0)

      expect(response).to have_http_status(:success)
      restaurant.reload
      expect(restaurant.active).to eq(false)
    end
  end
end
