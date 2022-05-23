require 'rails_helper'

RSpec.describe RestaurantType, type: :model do
  describe 'associations' do
    it { should have_many(:restaurants) }
  end

  describe 'validations' do
    it { should validate_presence_of(:type_name) }
    it { should validate_presence_of(:type_name_en) }
    it { should validate_presence_of(:constant_type) }
    it { should validate_uniqueness_of(:constant_type) }
  end
end
