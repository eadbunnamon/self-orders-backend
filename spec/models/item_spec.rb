require 'rails_helper'

RSpec.describe Item, type: :model do
  describe 'associations' do
    it { should belong_to(:category) }
    it { should have_one(:image) }
    it { should have_many(:options) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:name_en) }
    it { should validate_presence_of(:price) }
    it { should validate_uniqueness_of(:name).scoped_to(:category_id) }
    it { should validate_uniqueness_of(:name_en).scoped_to(:category_id) }
  end
end
