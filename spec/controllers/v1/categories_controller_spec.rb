require 'rails_helper'

RSpec.describe V1::CategoriesController, type: :controller do
  before(:each) do
    token = AuthToken.token(restaurant_admin)
    request.headers['Authorization'] = token
  end

  let!(:admin) { FactoryBot.create(:user, :admin) }
  let!(:restaurant_admin) { FactoryBot.create(:user, :restaurant_admin) }
  let!(:restaurant_admin_2) { FactoryBot.create(:user, :restaurant_admin) }

  let!(:general_restaurant) { FactoryBot.create(:restaurant_type, type_name: 'First', type_name_en: 'First EN', constant_type: 'general') }
  let!(:buffet_restaurant) { FactoryBot.create(:restaurant_type, type_name: 'Second', type_name_en: 'Second EN', constant_type: 'buffet') }

  let!(:restaurant_1) { FactoryBot.create(:restaurant, restaurant_type: general_restaurant, users: [restaurant_admin]) }
  let!(:restaurant_2) { FactoryBot.create(:restaurant, restaurant_type: general_restaurant, users: [restaurant_admin_2]) }

  let!(:category_1) { FactoryBot.create(:category, restaurant: restaurant_1) }
  let!(:category_2) { FactoryBot.create(:category, restaurant: restaurant_2) }

  context 'GET index' do
    it 'renders all categories' do
      get :index, params: { restaurant_id: restaurant_1.id }
      expect(response).to have_http_status(:ok)
      expect(assigns[:categories]).to include(category_1)
      expect(assigns[:categories]).not_to include(category_2)
    end
  end

  context 'POST create' do
    it 'create a new category' do
      expect {
        post :create, params: {
          restaurant_id: restaurant_1.id,
          category: {
            name: 'T1',
            name_en: 'T1-EN'
          }
        }
      }.to change(Category, :count).by(1)

      category = Category.order(created_at: :asc).last
      expect(category.name).to eq('T1')
      expect(category.name_en).to eq('T1-EN')
      expect(category.restaurant_id).to eq(restaurant_1.id)
    end
  end

  context 'PUT update' do
    it 'update a category' do
      expect {
        put :update, params: {
          id: category_1.id,
          restaurant_id: restaurant_1.id,
          category: {
            name: 'T-1-1',
            name_en: 'T1-EN-1'
          }
        }
      }.to change(Category, :count).by(0)

      category_1.reload
      expect(category_1.name).to eq('T-1-1')
      expect(category_1.name_en).to eq('T1-EN-1')
      expect(category_1.restaurant_id).to eq(restaurant_1.id)
    end
  end

  context 'GET show' do
    it 'get a category data' do
      get :show, params: { id: category_1.id, restaurant_id: restaurant_1.id }

      expect(response).to have_http_status(:success)
      response_body = JSON.parse(response.body).deep_symbolize_keys

      expect(response_body[:name]).to eq(category_1.name)
      expect(response_body[:name_en]).to eq(category_1.name_en)
      expect(response_body[:restaurant_id]).to eq(restaurant_1.id)
    end
  end

  context 'DELETE destroy' do
    it 'delete a category' do
      expect{
        delete :destroy, params: { id: category_1.id, restaurant_id: restaurant_1.id }
      }.to change(Category, :count).by(-1)

      expect(response).to have_http_status(:success)
    end
  end
end
