require 'rails_helper'

RSpec.describe RestaurantPolicy, type: :policy do
  subject { described_class }

  let!(:restaurant_type) { FactoryBot.create(:restaurant_type) }

  let!(:super_admin) { FactoryBot.create(:user, :super_admin) }
  let!(:admin) { FactoryBot.create(:user, :admin) }
  let!(:restaurant_admin) { FactoryBot.create(:user, :restaurant_admin) }
  let!(:restaurant_admin_2) { FactoryBot.create(:user, :restaurant_admin) }

  let!(:restaurant) { FactoryBot.create(:restaurant, users: [restaurant_admin]) }
  let!(:restaurant_2) { FactoryBot.create(:restaurant, users: [restaurant_admin_2]) }

  let(:user) { User.new }
  let(:scope) { Pundit.policy_scope!(user, Restaurant) }

  describe "Scope" do
    context 'restaurant admin' do
      let(:user) { restaurant_admin }
      it 'allows a limited restaurants' do
        expect(scope.to_a).to match_array([restaurant])
        expect(scope.to_a).not_to match_array([restaurant_2])
      end 
    end

    context 'super admin' do
      let(:user) { super_admin }
      it 'allows all restaurants' do
        expect(scope.to_a).to match_array([restaurant, restaurant_2])
      end 
    end

    context 'admin' do
      let(:user) { admin }
      it 'allows all restaurants' do
        expect(scope.to_a).to match_array([restaurant, restaurant_2])
      end 
    end
  end

  permissions :index? do
    it "grants access for only all admins" do
      expect(subject).to permit(super_admin)
      expect(subject).to permit(admin)
      expect(subject).to permit(restaurant_admin)
      expect(subject).to permit(restaurant_admin_2)
    end
  end

  permissions :new? do
    it "grants access for only all admins" do
      expect(subject).to permit(super_admin, Restaurant.new)
      expect(subject).to permit(admin, Restaurant.new)
      expect(subject).to permit(restaurant_admin, Restaurant.new)
      expect(subject).to permit(restaurant_admin_2, Restaurant.new)
    end
  end

  permissions :create? do
    it "grants access for only all admins" do
      expect(subject).to permit(super_admin, Restaurant.new)
      expect(subject).to permit(admin, Restaurant.new)
      expect(subject).to permit(restaurant_admin, Restaurant.new)
      expect(subject).to permit(restaurant_admin_2, Restaurant.new)
    end
  end

  permissions :update? do
    it "grants access for only all admins" do
      expect(subject).to permit(super_admin, restaurant)
      expect(subject).to permit(super_admin, restaurant_2)

      expect(subject).to permit(admin, restaurant)
      expect(subject).to permit(admin, restaurant_2)

      expect(subject).to permit(restaurant_admin, restaurant)
      expect(subject).not_to permit(restaurant_admin, restaurant_2)

      expect(subject).not_to permit(restaurant_admin_2, restaurant)
      expect(subject).to permit(restaurant_admin_2, restaurant_2)
    end
  end

  permissions :show? do
    it "grants access for only all admins" do
      expect(subject).to permit(super_admin, restaurant)
      expect(subject).to permit(super_admin, restaurant_2)

      expect(subject).to permit(admin, restaurant)
      expect(subject).to permit(admin, restaurant_2)

      expect(subject).to permit(restaurant_admin, restaurant)
      expect(subject).not_to permit(restaurant_admin, restaurant_2)

      expect(subject).not_to permit(restaurant_admin_2, restaurant)
      expect(subject).to permit(restaurant_admin_2, restaurant_2)
    end
  end

  permissions :destroy? do
    it "grants access for only all admins" do
      expect(subject).to permit(super_admin, restaurant)
      expect(subject).to permit(super_admin, restaurant_2)

      expect(subject).to permit(admin, restaurant)
      expect(subject).to permit(admin, restaurant_2)

      expect(subject).to permit(restaurant_admin, restaurant)
      expect(subject).not_to permit(restaurant_admin, restaurant_2)

      expect(subject).not_to permit(restaurant_admin_2, restaurant)
      expect(subject).to permit(restaurant_admin_2, restaurant_2)
    end
  end
end
