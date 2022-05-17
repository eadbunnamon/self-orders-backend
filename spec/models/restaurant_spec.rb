require 'rails_helper'

RSpec.describe Restaurant, type: :model do
  describe 'associations' do
    it { should belong_to(:restaurant_type) }
    it { should have_many(:categories) }
    it { should have_many(:tables) }
    it { should have_many(:images) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:name_en) }
    it { should validate_presence_of(:open_time) }
    it { should validate_presence_of(:close_time) }
  end
end
