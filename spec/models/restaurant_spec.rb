require 'rails_helper'

RSpec.describe Restaurant, type: :model do
  describe 'associations' do
    it { should belong_to(:restaurant_type) }
    it { should have_many(:categories) }
    it { should have_many(:tables) }
    it { should have_one(:image) }
    it { should have_and_belong_to_many(:users) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:name_en) }
  end
end
