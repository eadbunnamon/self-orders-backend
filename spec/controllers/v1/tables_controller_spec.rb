require 'rails_helper'

RSpec.describe V1::TablesController, type: :controller do
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

  let!(:table_1) { FactoryBot.create(:table, name: 'Table 1', restaurant: restaurant_1) }
  let!(:table_2) { FactoryBot.create(:table, restaurant: restaurant_2) }

  context 'GET index' do
    it 'renders all tables' do
      get :index, params: { restaurant_id: restaurant_1.id }
      expect(response).to have_http_status(:ok)
      expect(assigns[:tables]).to include(table_1)
      expect(assigns[:tables]).not_to include(table_2)
    end
  end

  context 'POST create' do
    it 'create a new table' do
      expect {
        post :create, params: {
          restaurant_id: restaurant_1.id,
          table: {
            name: 'TX',
            amount: ''
          }
        }
      }.to change(Table, :count).by(1)

      table = Table.order(created_at: :desc).first
      expect(table.name).to eq('TX')
      expect(table.restaurant_id).to eq(restaurant_1.id)
    end

    it 'create new multiple tables' do
      expect {
        post :create, params: {
          restaurant_id: restaurant_1.id,
          table: {
            name: 'T1',
            amount: 2
          }
        }
      }.to change(Table, :count).by(2)

      table = Table.order(created_at: :desc).first
      expect(table.name).to eq('T1 2')
      expect(table.restaurant_id).to eq(restaurant_1.id)

      table_2 = Table.order(created_at: :desc).second
      expect(table_2.name).to eq('T1 1')
      expect(table_2.restaurant_id).to eq(restaurant_1.id)
    end

    it 'rollback when got error from multiple create tables' do
      expect {
        post :create, params: {
          restaurant_id: restaurant_1.id,
          table: {
            name: 'Table',
            amount: 2
          }
        }
      }.to change(Table, :count).by(0)
    end
  end

  context 'PUT update' do
    it 'update a table' do
      expect {
        put :update, params: {
          id: table_1.id,
          restaurant_id: restaurant_1.id,
          table: {
            name: 'T-1'
          }
        }
      }.to change(Table, :count).by(0)

      table_1.reload
      expect(table_1.name).to eq('T-1')
      expect(table_1.restaurant_id).to eq(restaurant_1.id)
    end
  end

  context 'GET show' do
    it 'get a table data' do
      get :show, params: { id: table_1.id, restaurant_id: restaurant_1.id }

      expect(response).to have_http_status(:success)
      response_body = JSON.parse(response.body).deep_symbolize_keys

      expect(response_body[:name]).to eq(table_1.name)
      expect(response_body[:restaurant_id]).to eq(restaurant_1.id)
    end
  end

  context 'DELETE destroy' do
    it 'delete a table' do
      expect{
        delete :destroy, params: { id: table_1.id, restaurant_id: restaurant_1.id }
      }.to change(Table, :count).by(-1)

      expect(response).to have_http_status(:success)
    end
  end
end
