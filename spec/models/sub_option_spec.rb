require 'rails_helper'

RSpec.describe SubOption, type: :model do
  describe 'associations' do
    it { should belong_to(:option) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:name_en) }
    # it { should validate_uniqueness_of(:name).scoped_to(:option_id) }
    # it { should validate_uniqueness_of(:name_en).scoped_to(:option_id) }
  end
end
