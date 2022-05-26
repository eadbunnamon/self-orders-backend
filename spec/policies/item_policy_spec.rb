require 'rails_helper'

RSpec.describe ItemPolicy, type: :policy do
  subject { described_class }

  let!(:restaurant_type) { FactoryBot.create(:restaurant_type) }

  let!(:super_admin) { FactoryBot.create(:user, :super_admin) }
  let!(:admin) { FactoryBot.create(:user, :admin) }
  let!(:restaurant_admin) { FactoryBot.create(:user, :restaurant_admin) }
  let!(:restaurant_admin_2) { FactoryBot.create(:user, :restaurant_admin) }

  let!(:restaurant_1) { FactoryBot.create(:restaurant, users: [restaurant_admin]) }
  let!(:restaurant_2) { FactoryBot.create(:restaurant, users: [restaurant_admin_2]) }

  let!(:category_1) { FactoryBot.create(:category, restaurant: restaurant_1) }
  let!(:category_2) { FactoryBot.create(:category, restaurant: restaurant_2) }

  let!(:item_1) { FactoryBot.create(:item, category: category_1) }
  let!(:item_2) { FactoryBot.create(:item, category: category_2) }

  let(:user) { User.new }
  let(:scope) { Pundit.policy_scope!(user, Item) }

  describe "Scope" do
    describe 'restaurant admin' do
      context 'can see all items restaurant_1' do
        let(:user) { restaurant_admin }
        let(:scope) { Pundit.policy_scope!(user, Item.where(category_id: category_1.id)) }
        it 'allows all items restaurant_1' do
          expect(scope.to_a).to match_array([item_1])
          expect(scope.to_a).not_to match_array([item_2])
        end 
      end
    end

    describe 'super admin' do
      context 'can see all items restaurant_1' do
        let(:user) { super_admin }
        let(:scope) { Pundit.policy_scope!(user, Item.where(category_id: category_1.id)) }
        it 'allows all items restaurant_1' do
          expect(scope.to_a).to match_array([item_1])
          expect(scope.to_a).not_to match_array([item_2])
        end 
      end

      context 'can see all items restaurant_2' do
        let(:user) { super_admin }
        let(:scope) { Pundit.policy_scope!(user, Item.where(category_id: category_2.id)) }
        it 'allows all items restaurant_2' do
          expect(scope.to_a).to match_array([item_2])
          expect(scope.to_a).not_to match_array([item_1])
        end 
      end
    end

    describe 'admin' do
      context 'can see all items restaurant_1' do
        let(:user) { admin }
        let(:scope) { Pundit.policy_scope!(user, Item.where(category_id: category_1.id)) }
        it 'allows all items restaurant_1' do
          expect(scope.to_a).to match_array([item_1])
          expect(scope.to_a).not_to match_array([item_2])
        end 
      end

      context 'can see all items restaurant_2' do
        let(:user) { admin }
        let(:scope) { Pundit.policy_scope!(user, Item.where(category_id: category_2.id)) }
        it 'allows all items restaurant_2' do
          expect(scope.to_a).to match_array([item_2])
          expect(scope.to_a).not_to match_array([item_1])
        end 
      end
    end
  end

  permissions :index? do
    it "grants access" do
      expect(subject).to permit(super_admin)
      expect(subject).to permit(admin)
      expect(subject).to permit(restaurant_admin)
      expect(subject).to permit(restaurant_admin_2)
    end
  end

  permissions :new? do
    it "grants access" do
      expect(subject).to permit(super_admin, Item.new)
      expect(subject).to permit(admin, Item.new)
      expect(subject).to permit(restaurant_admin, Item.new)
      expect(subject).to permit(restaurant_admin_2, Item.new)
    end
  end

  permissions :create? do
    it "grants access" do
      expect(subject).to permit(super_admin, Item.new)
      expect(subject).to permit(admin, Item.new)
      expect(subject).to permit(restaurant_admin, Item.new)
      expect(subject).to permit(restaurant_admin_2, Item.new)
    end
  end

  permissions :update?, :show?, :destroy? do
    it "grants access" do
      expect(subject).to permit(super_admin, item_1)
      expect(subject).to permit(super_admin, item_2)

      expect(subject).to permit(admin, item_1)
      expect(subject).to permit(admin, item_2)

      expect(subject).to permit(restaurant_admin, item_1)
      expect(subject).not_to permit(restaurant_admin, item_2)

      expect(subject).not_to permit(restaurant_admin_2, item_1)
      expect(subject).to permit(restaurant_admin_2, item_2)
    end
  end
end
