require 'rails_helper'

RSpec.describe V1::RestaurantTypesController, type: :controller do
  before(:each) do
    role = FactoryBot.create(:role, name: 'super_admin')
    super_admin = FactoryBot.create(:user, roles: [role])

    token = AuthToken.token(super_admin)
    request.headers['Authorization'] = token
  end

  describe 'GET index' do
    it 'renders all restaurant types' do
      restaurant_type_1 = FactoryBot.create(:restaurant_type, type_name: 'First', type_name_en: 'First EN')
      restaurant_type_2 = FactoryBot.create(:restaurant_type, type_name: 'Second', type_name_en: 'Second EN')

      get :index
      expect(response).to have_http_status(:ok)
      expect(assigns[:restaurant_types]).to include(restaurant_type_1)
      expect(assigns(:restaurant_types)).to include(restaurant_type_2)
    end
  end
end
