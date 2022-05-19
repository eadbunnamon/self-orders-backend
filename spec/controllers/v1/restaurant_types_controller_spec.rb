require 'rails_helper'

RSpec.describe V1::RestaurantTypesController, type: :controller do
  describe 'GET index' do
    it 'renders all restaurant types' do
      restaurant_type_1 = FactoryBot.create(:restaurant_type, type_name: 'First', type_name_en: 'First EN')
      restaurant_type_2 = FactoryBot.create(:restaurant_type, type_name: 'Second', type_name_en: 'Second EN')

      role = FactoryBot.create(:role, name: 'super_admin')
      super_admin = FactoryBot.create(:user, roles: [role])
      sign_in_as(super_admin) do
        get :index
        expect(response).to have_http_status(:ok)
        expect(assigns[:restaurant_types]).to include(restaurant_type_1)
        expect(assigns(:restaurant_types)).to include(restaurant_type_2)
      end
    end
  end
end
