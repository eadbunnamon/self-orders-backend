require 'rails_helper'

RSpec.describe V1::ItemsController, type: :controller do
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

  let!(:item_1) { FactoryBot.create(:item, category: category_1) }
  let!(:item_2) { FactoryBot.create(:item, category: category_1) }
  let!(:item_3) { FactoryBot.create(:item, category: category_2) }

  context 'GET index' do
    it 'renders all items' do
      get :index, params: { category_id: category_1.id }
      expect(response).to have_http_status(:ok)
      expect(assigns[:items]).to include(item_1)
      expect(assigns[:items]).to include(item_2)
      expect(assigns[:items]).not_to include(item_3)
    end
  end

  context 'POST create' do
    it 'create a new item' do
      expect {
        post :create, params: {
          category_id: category_1.id,
          item: {
            name: 'Item#1',
            name_en: 'Item#1 EN',
            image_attributes: {
              file: Rack::Test::UploadedFile.new(Rails.root.join('spec', 'support', 'image_1.jpg'))
            }
          }
        }
      }.to change(Item, :count).by(1)

      item = Item.order(created_at: :asc).last
      expect(item.name).to eq('Item#1')
      expect(item.name_en).to eq('Item#1 EN')
      expect(item.category_id).to eq(category_1.id)

      expect(item.image&.imageable_type).to eq('Item')
      expect(item.image&.imageable_id).to eq(item.id)
    end
  end

  context 'PUT update' do
    it 'update a item' do
      file = Rack::Test::UploadedFile.new(Rails.root.join('spec', 'support', 'image_1.jpg'))
      image = FactoryBot.create(:image, imageable: item_1, file: file)
      expect {
        put :update, params: {
          id: item_1.id,
          category_id: category_1.id,
          item: {
            name: 'T-1-1',
            name_en: 'T1-EN-1',
            image_attributes: {
              id: image.id,
              file: Rack::Test::UploadedFile.new(Rails.root.join('spec', 'support', 'image_2.jpg'))
            }
          }
        }
      }.to change(Item, :count).by(0)

      item_1.reload
      expect(item_1.name).to eq('T-1-1')
      expect(item_1.name_en).to eq('T1-EN-1')
      expect(item_1.category_id).to eq(category_1.id)

      expect(item_1.image&.imageable_type).to eq('Item')
      expect(item_1.image&.imageable_id).to eq(item_1.id)
    end
  end

  context 'GET show' do
    it 'get a item data' do
      get :show, params: { id: item_1.id, category_id: category_1.id }

      expect(response).to have_http_status(:success)
      response_body = JSON.parse(response.body).deep_symbolize_keys

      expect(response_body[:name]).to eq(item_1.name)
      expect(response_body[:name_en]).to eq(item_1.name_en)
      expect(response_body[:category_id]).to eq(category_1.id)
    end
  end

  context 'DELETE destroy' do
    it 'delete a category' do
      expect{
        delete :destroy, params: { id: item_1.id, category_id: category_1.id }
      }.to change(Item, :count).by(-1)

      expect(response).to have_http_status(:success)
      expect(category_1.reload.items.count).to eq(1)
    end
  end
end
