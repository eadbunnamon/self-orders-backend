require 'rails_helper'

RSpec.describe V1::RestaurantTypesController, type: :controller do
  before(:each) do
    super_admin = FactoryBot.create(:user, :super_admin)
    token = AuthToken.token(super_admin)
    request.headers['Authorization'] = token
  end

  let!(:general_restaurant) { FactoryBot.create(:restaurant_type, type_name: 'First', type_name_en: 'First EN', constant_type: 'general') }
  let!(:buffet_restaurant) { FactoryBot.create(:restaurant_type, type_name: 'Second', type_name_en: 'Second EN', constant_type: 'buffet') }

  context 'GET index' do
    it 'renders all restaurant types' do
      get :index
      expect(response).to have_http_status(:ok)
      expect(assigns[:restaurant_types]).to include(general_restaurant)
      expect(assigns(:restaurant_types)).to include(buffet_restaurant)
    end
  end
end
