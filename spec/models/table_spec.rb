require 'rails_helper'

RSpec.describe Table, type: :model do
  describe 'associations' do
    it { should belong_to(:restaurant) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name).scoped_to(:restaurant_id) }
  end
end
