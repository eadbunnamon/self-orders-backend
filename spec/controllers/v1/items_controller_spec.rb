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

  let!(:sub_option_1) { FactoryBot.create(:sub_option, option: option_1) }

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
            price: 60,
            image_attributes: {
              file: Rack::Test::UploadedFile.new(Rails.root.join('spec', 'support', 'image_1.jpg'))
            },
            options_attributes: [
              {
                name: 'ขนาด',
                name_en: 'Size',
                need_to_choose: true,
                maximum_choose: 1,
                sub_options_attributes: [
                  {
                    name: 'ธรรมดา',
                    name_en: 'Normal',
                    additional_price: 0
                  },
                  {
                    name: 'พิเศษ',
                    name_en: 'Jumbo',
                    additional_price: 10
                  }
                ]
              },
              {
                name: 'ไข่',
                name_en: 'Egg',
                need_to_choose: false,
                maximum_choose: 2,
                sub_options_attributes: [
                  {
                    name: 'ไข่ดาว',
                    name_en: 'Fried Egg',
                    additional_price: 7
                  },
                  {
                    name: 'ไข่เจียว',
                    name_en: 'Omelet',
                    additional_price: 10
                  }
                ]
              }
            ]
          }
        }
      }.to change(Item, :count).by(1)

      item = Item.order(created_at: :asc).last
      expect(item.name).to eq('Item#1')
      expect(item.name_en).to eq('Item#1 EN')
      expect(item.price).to eq(60)
      expect(item.category_id).to eq(category_1.id)

      # expect(item.image&.imageable_type).to eq('Item')
      # expect(item.image&.imageable_id).to eq(item.id)

      expect(item.options.count).to eq(2)
      opt1 = item.options.order(created_at: :asc).first
      opt2 = item.options.order(created_at: :asc).last

      expect(opt1&.name).to eq('ขนาด')
      expect(opt1&.name_en).to eq('Size')
      expect(opt1&.need_to_choose).to eq(true)
      expect(opt1&.maximum_choose).to eq(1)

      expect(opt2&.name).to eq('ไข่')
      expect(opt2&.name_en).to eq('Egg')
      expect(opt2&.need_to_choose).to eq(false)
      expect(opt2&.maximum_choose).to eq(2)

      expect(opt1.sub_options.count).to eq(2)
      expect(opt1.sub_options.pluck(:name)).to include('ธรรมดา')
      expect(opt1.sub_options.pluck(:name)).to include('พิเศษ')
      expect(opt1.sub_options.pluck(:name_en)).to include('Normal')
      expect(opt1.sub_options.pluck(:name_en)).to include('Jumbo')
      expect(opt1.sub_options.pluck(:additional_price)).to include(0)
      expect(opt1.sub_options.pluck(:additional_price)).to include(10)

      expect(opt2.sub_options.count).to eq(2)
      expect(opt2.sub_options.pluck(:name)).to include('ไข่ดาว')
      expect(opt2.sub_options.pluck(:name)).to include('ไข่เจียว')
      expect(opt2.sub_options.pluck(:name_en)).to include('Fried Egg')
      expect(opt2.sub_options.pluck(:name_en)).to include('Omelet')
      expect(opt2.sub_options.pluck(:additional_price)).to include(7)
      expect(opt2.sub_options.pluck(:additional_price)).to include(10)
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
            price: 69,
            image_attributes: {
              file: Rack::Test::UploadedFile.new(Rails.root.join('spec', 'support', 'image_1.jpg'))
            },
            options_attributes: [
              {
                id: option_1.id,
                name: 'ขนาด',
                name_en: 'Size',
                need_to_choose: true,
                maximum_choose: 1,
                sub_options_attributes: [
                  {
                    id: sub_option_1.id,
                    name: 'ธรรมดา',
                    name_en: 'Normal',
                    additional_price: 0
                  },
                  {
                    id: '',
                    name: 'พิเศษ',
                    name_en: 'Jumbo',
                    additional_price: 15
                  }
                ]
              }
            ]
          }
        }
      }.to change(Item, :count).by(0)

      item_1.reload
      expect(item_1.name).to eq('T-1-1')
      expect(item_1.name_en).to eq('T1-EN-1')
      expect(item_1.price).to eq(69)
      expect(item_1.category_id).to eq(category_1.id)

      # expect(item_1.image&.imageable_type).to eq('Item')
      # expect(item_1.image&.imageable_id).to eq(item_1.id)

      expect(item_1.options.count).to eq(1)
      opt1 = item_1.options.first
      
      expect(opt1&.id).to eq(option_1.id)
      expect(opt1&.name).to eq('ขนาด')
      expect(opt1&.name_en).to eq('Size')
      expect(opt1&.need_to_choose).to eq(true)
      expect(opt1&.maximum_choose).to eq(1)

      expect(opt1.sub_options.count).to eq(2)
      expect(opt1.sub_options.pluck(:name)).to include('ธรรมดา')
      expect(opt1.sub_options.pluck(:name)).to include('พิเศษ')
      expect(opt1.sub_options.pluck(:name_en)).to include('Normal')
      expect(opt1.sub_options.pluck(:name_en)).to include('Jumbo')
      expect(opt1.sub_options.pluck(:additional_price)).to include(0)
      expect(opt1.sub_options.pluck(:additional_price)).to include(15)
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

      expect(response_body[:options].count).to eq(1)
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
