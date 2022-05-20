require 'rails_helper'

RSpec.describe RestaurantTypePolicy, type: :policy do
  subject { described_class }

  let(:restaurant_type) { FactoryBot.create(:restaurant_type) }

  let(:super_admin_role) { FactoryBot.create(:role, name: 'super_admin') }
  let(:admin_role) { FactoryBot.create(:role, name: 'admin') }
  let(:restaurant_admin_role) { FactoryBot.create(:role, name: 'restaurant_admin') }
  let(:super_admin) { FactoryBot.create(:user, roles: [super_admin_role]) }
  let(:admin) { FactoryBot.create(:user, roles: [admin_role]) }
  let(:restaurant_admin) { FactoryBot.create(:user, roles: [restaurant_admin_role]) }

  permissions :index? do
    it "grants access for only admin" do
      expect(subject).to permit(super_admin, restaurant_type)
      expect(subject).to permit(admin, restaurant_type)
      expect(subject).to permit(restaurant_admin, restaurant_type)
    end
  end
end
