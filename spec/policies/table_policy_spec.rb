require 'rails_helper'

RSpec.describe TablePolicy, type: :policy do
  subject { described_class }

  let!(:restaurant_type) { FactoryBot.create(:restaurant_type) }

  let!(:super_admin) { FactoryBot.create(:user, :super_admin) }
  let!(:admin) { FactoryBot.create(:user, :admin) }
  let!(:restaurant_admin) { FactoryBot.create(:user, :restaurant_admin) }
  let!(:restaurant_admin_2) { FactoryBot.create(:user, :restaurant_admin) }

  let!(:restaurant_1) { FactoryBot.create(:restaurant, users: [restaurant_admin]) }
  let!(:restaurant_2) { FactoryBot.create(:restaurant, users: [restaurant_admin]) }
  let!(:restaurant_3) { FactoryBot.create(:restaurant, users: [restaurant_admin_2]) }

  let!(:table_1) { FactoryBot.create(:table, restaurant: restaurant_1) }
  let!(:table_2) { FactoryBot.create(:table, restaurant: restaurant_1) }
  let!(:table_3) { FactoryBot.create(:table, restaurant: restaurant_2) }
  let!(:table_4) { FactoryBot.create(:table, restaurant: restaurant_3) }

  let(:user) { User.new }
  let(:scope) { Pundit.policy_scope!(user, Table) }

  describe "Scope" do
    describe 'restaurant admin' do
      context 'can see all tables restaurant_1' do
        let(:user) { restaurant_admin }
        let(:scope) { Pundit.policy_scope!(user, Table.where(restaurant_id: restaurant_1.id)) }
        it 'allows all tables restaurant_1' do
          expect(scope.to_a).to match_array([table_1, table_2])
          expect(scope.to_a).not_to match_array([table_3, table_4])
        end 
      end

      context 'can see all tables restaurant_2' do
        let(:user) { restaurant_admin }
        let(:scope) { Pundit.policy_scope!(user, Table.where(restaurant_id: restaurant_2.id)) }
        it 'allows all tables restaurant_2' do
          expect(scope.to_a).to match_array([table_3])
          expect(scope.to_a).not_to match_array([table_1, table_2, table_4])
        end 
      end
    end

    describe 'super admin' do
      context 'can see all tables restaurant_1' do
        let(:user) { super_admin }
        let(:scope) { Pundit.policy_scope!(user, Table.where(restaurant_id: restaurant_1.id)) }
        it 'allows all tables restaurant_1' do
          expect(scope.to_a).to match_array([table_1, table_2])
          expect(scope.to_a).not_to match_array([table_3, table_4])
        end 
      end

      context 'can see all tables restaurant_2' do
        let(:user) { super_admin }
        let(:scope) { Pundit.policy_scope!(user, Table.where(restaurant_id: restaurant_2.id)) }
        it 'allows all tables restaurant_2' do
          expect(scope.to_a).to match_array([table_3])
          expect(scope.to_a).not_to match_array([table_1, table_2, table_4])
        end 
      end

      context 'can see all tables restaurant_3' do
        let(:user) { super_admin }
        let(:scope) { Pundit.policy_scope!(user, Table.where(restaurant_id: restaurant_3.id)) }
        it 'allows all tables restaurant_3' do
          expect(scope.to_a).to match_array([table_4])
          expect(scope.to_a).not_to match_array([table_1, table_2, table_3])
        end 
      end
    end

    describe 'admin' do
      context 'can see all tables restaurant_1' do
        let(:user) { admin }
        let(:scope) { Pundit.policy_scope!(user, Table.where(restaurant_id: restaurant_1.id)) }
        it 'allows all tables restaurant_1' do
          expect(scope.to_a).to match_array([table_1, table_2])
          expect(scope.to_a).not_to match_array([table_3, table_4])
        end 
      end

      context 'can see all tables restaurant_2' do
        let(:user) { admin }
        let(:scope) { Pundit.policy_scope!(user, Table.where(restaurant_id: restaurant_2.id)) }
        it 'allows all tables restaurant_2' do
          expect(scope.to_a).to match_array([table_3])
          expect(scope.to_a).not_to match_array([table_1, table_2, table_4])
        end 
      end

      context 'can see all tables restaurant_3' do
        let(:user) { admin }
        let(:scope) { Pundit.policy_scope!(user, Table.where(restaurant_id: restaurant_3.id)) }
        it 'allows all tables restaurant_3' do
          expect(scope.to_a).to match_array([table_4])
          expect(scope.to_a).not_to match_array([table_1, table_2, table_3])
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
      expect(subject).to permit(super_admin, Table.new)
      expect(subject).to permit(admin, Table.new)
      expect(subject).to permit(restaurant_admin, Table.new)
      expect(subject).to permit(restaurant_admin_2, Table.new)
    end
  end

  permissions :create? do
    it "grants access" do
      expect(subject).to permit(super_admin, Table.new)
      expect(subject).to permit(admin, Table.new)
      expect(subject).to permit(restaurant_admin, Table.new)
      expect(subject).to permit(restaurant_admin_2, Table.new)
    end
  end

  permissions :update?, :show?, :destroy? do
    it "grants access" do
      expect(subject).to permit(super_admin, table_1)
      expect(subject).to permit(super_admin, table_2)
      expect(subject).to permit(super_admin, table_3)
      expect(subject).to permit(super_admin, table_4)

      expect(subject).to permit(admin, table_1)
      expect(subject).to permit(admin, table_2)
      expect(subject).to permit(admin, table_3)
      expect(subject).to permit(admin, table_4)

      expect(subject).to permit(restaurant_admin, table_1)
      expect(subject).to permit(restaurant_admin, table_2)
      expect(subject).to permit(restaurant_admin, table_3)
      expect(subject).not_to permit(restaurant_admin, table_4)

      expect(subject).not_to permit(restaurant_admin_2, table_1)
      expect(subject).not_to permit(restaurant_admin_2, table_2)
      expect(subject).not_to permit(restaurant_admin_2, table_3)
      expect(subject).to permit(restaurant_admin_2, table_4)
    end
  end
end
