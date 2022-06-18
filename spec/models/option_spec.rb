require 'rails_helper'

RSpec.describe Option, type: :model do
  describe 'associations' do
    it { should belong_to(:item) }
  end

  describe 'validations' do
    it { should validate_presence_of(:size) }
    it { should validate_presence_of(:price) }
    it { should validate_uniqueness_of(:size).scoped_to(:item_id) }
  end
end
