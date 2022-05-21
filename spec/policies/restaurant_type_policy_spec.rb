require 'rails_helper'

RSpec.describe RestaurantTypePolicy, type: :policy do
  subject { described_class }

  let(:restaurant_type) { FactoryBot.create(:restaurant_type) }

  let(:super_admin) { FactoryBot.create(:user, :super_admin) }
  let(:admin) { FactoryBot.create(:user, :admin) }
  let(:restaurant_admin) { FactoryBot.create(:user, :restaurant_admin) }

  permissions :index? do
    it "grants access for all admins" do
      expect(subject).to permit(super_admin, restaurant_type)
      expect(subject).to permit(admin, restaurant_type)
      expect(subject).to permit(restaurant_admin, restaurant_type)
    end
  end
end
