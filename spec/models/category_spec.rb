require 'rails_helper'

RSpec.describe Category, type: :model do
  describe 'associations' do
    it { should belong_to(:restaurant) }
    it { should have_many(:items) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:name_en) }
    it { should validate_uniqueness_of(:name).scoped_to(:restaurant_id) }
  end
end
