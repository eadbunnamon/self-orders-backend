require 'rails_helper'

RSpec.describe RestaurantType, type: :model do
  describe 'associations' do
    it { should have_many(:restaurants) }
  end

  describe 'validations' do
    it { should validate_presence_of(:type_name) }
    it { should validate_presence_of(:type_name_en) }
  end
end
