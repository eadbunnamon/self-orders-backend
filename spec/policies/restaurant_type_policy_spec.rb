require 'rails_helper'

RSpec.describe RestaurantTypePolicy, type: :policy do
  subject { described_class }

  let!(:restaurant_type) { FactoryBot.create(:restaurant_type) }
  let!(:restaurant_type_2) { FactoryBot.create(:restaurant_type, restaurant_type: 'buffet', active: false) }

  let(:super_admin) { FactoryBot.create(:user, :super_admin) }
  let(:admin) { FactoryBot.create(:user, :admin) }
  let(:restaurant_admin) { FactoryBot.create(:user, :restaurant_admin) }

  let(:user) { User.new }
  let(:scope) { Pundit.policy_scope!(user, RestaurantType) }

  describe "Scope" do
    context 'restaurant admin' do
      let(:user) { restaurant_admin }
      it 'allows a limited restaurant types' do
        expect(scope.to_a).to match_array([restaurant_type])
        expect(scope.to_a).not_to match_array([restaurant_type_2])
      end 
    end

    context 'super admin' do
      let(:user) { super_admin }
      it 'allows all restaurant types' do
        expect(scope.to_a).to match_array([restaurant_type, restaurant_type_2])
      end 
    end

    context 'admin' do
      let(:user) { admin }
      it 'allows all restaurant types' do
        expect(scope.to_a).to match_array([restaurant_type, restaurant_type_2])
      end 
    end
  end

  permissions :index? do
    it "grants access for all admins" do
      expect(subject).to permit(super_admin, restaurant_type)
      expect(subject).to permit(admin, restaurant_type)
      expect(subject).to permit(restaurant_admin, restaurant_type)
    end
  end
end
