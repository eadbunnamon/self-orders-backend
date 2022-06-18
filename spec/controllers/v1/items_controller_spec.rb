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

  let!(:option_1) { FactoryBot.create(:option, item: item_1) }
  let!(:option_2) { FactoryBot.create(:option, size: 'Jumbo', is_default: false, item: item_1) }

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
            },
            options_attributes: [
              { size: 'Normal', price: 150, is_default: true },
              { size: 'Jumbo', price: 240, is_default: false }
            ]
          }
        }
      }.to change(Item, :count).by(1)

      item = Item.order(created_at: :asc).last
      expect(item.name).to eq('Item#1')
      expect(item.name_en).to eq('Item#1 EN')
      expect(item.category_id).to eq(category_1.id)

      expect(item.image&.imageable_type).to eq('Item')
      expect(item.image&.imageable_id).to eq(item.id)

      expect(item.options.count).to eq(2)
      opt1 = item.options.order(created_at: :asc).first
      opt2 = item.options.order(created_at: :asc).last

      expect(opt1&.size).to eq('Normal')
      expect(opt1&.price.to_f).to eq(150.to_f)
      expect(opt1&.is_default).to eq(true)

      expect(opt2&.size).to eq('Jumbo')
      expect(opt2&.price.to_f).to eq(240.to_f)
      expect(opt2&.is_default).to eq(false)
    end

    it 'cannot create item if at least an option is invalid' do
      expect {
        post :create, params: {
          category_id: category_1.id,
          item: {
            name: 'Item#1',
            name_en: 'Item#1 EN',
            image_attributes: {
              file: Rack::Test::UploadedFile.new(Rails.root.join('spec', 'support', 'image_1.jpg'))
            },
            options_attributes: [
              { size: 'Normal', price: 150, is_default: true },
              { size: 'Jumbo', price: 240, is_default: true }
            ]
          }
        }
      }.to change(Item, :count).by(0)
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
            },
            options_attributes: [
              { id: option_1.id, size: 'Normal-II', price: 160, is_default: false },
              { id: option_2.id, size: 'Jumbo-II', price: 160, is_default: true, _destroy: true },
              { id: '', size: 'Big-II', price: 300, is_default: true }
            ]
          }
        }
      }.to change(Item, :count).by(0)

      item_1.reload
      expect(item_1.name).to eq('T-1-1')
      expect(item_1.name_en).to eq('T1-EN-1')
      expect(item_1.category_id).to eq(category_1.id)

      expect(item_1.image&.imageable_type).to eq('Item')
      expect(item_1.image&.imageable_id).to eq(item_1.id)

      expect(item_1.options.count).to eq(2)
      opt1 = item_1.options.order(created_at: :asc).first
      opt2 = item_1.options.order(created_at: :asc).last
      
      expect(opt1&.id).to eq(option_1.id)
      expect(opt1&.size).to eq('Normal-II')
      expect(opt1&.price.to_f).to eq(160.to_f)
      expect(opt1&.is_default).to eq(false)

      expect(opt2&.size).to eq('Big-II')
      expect(opt2&.price.to_f).to eq(300.to_f)
      expect(opt2&.is_default).to eq(true)
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

      expect(response_body[:options].count).to eq(2)
    end
  end

  context 'DELETE destroy' do
    it 'delete a category' do
      item_id = item_1.id
      option_ids = item_1.options.pluck(:id)
      expect{
        delete :destroy, params: { id: item_1.id, category_id: category_1.id }
      }.to change(Item, :count).by(-1)

      expect(response).to have_http_status(:success)
      expect(category_1.reload.items.count).to eq(1)

      expect(Option.where(id: option_ids).count).to eq(0)
    end
  end
end
