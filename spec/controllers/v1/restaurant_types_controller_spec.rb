require 'rails_helper'

RSpec.describe V1::RestaurantTypesController, type: :controller do
  let!(:general_restaurant) { FactoryBot.create(:restaurant_type, constant_type: 'general') }
  let!(:buffet_restaurant) { FactoryBot.create(:restaurant_type, constant_type: 'buffet', active: false) }

  context 'GET index' do
    it 'renders all restaurant types if login by super admin' do
      super_admin = FactoryBot.create(:user, :super_admin)
      token = AuthToken.token(super_admin)
      request.headers['Authorization'] = token

      get :index
      expect(response).to have_http_status(:ok)
      expect(assigns[:restaurant_types]).to include(general_restaurant)
      expect(assigns[:restaurant_types]).to include(buffet_restaurant)
    end
    it 'renders all restaurant types if login by admin' do
      admin = FactoryBot.create(:user, :admin)
      token = AuthToken.token(admin)
      request.headers['Authorization'] = token

      get :index
      expect(response).to have_http_status(:ok)
      expect(assigns[:restaurant_types]).to include(general_restaurant)
      expect(assigns(:restaurant_types)).to include(buffet_restaurant)
    end

    it 'renders only active restaurant types if login by restaurant admin' do
      restaurant_admin = FactoryBot.create(:user, :restaurant_admin)
      token = AuthToken.token(restaurant_admin)
      request.headers['Authorization'] = token

      get :index
      expect(response).to have_http_status(:ok)
      expect(assigns[:restaurant_types]).to include(general_restaurant)
      expect(assigns(:restaurant_types)).not_to include(buffet_restaurant)
    end
  end
end
