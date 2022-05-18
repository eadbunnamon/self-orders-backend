require 'rails_helper'

RSpec.describe Staff, type: :model do
  describe 'associations' do
    it { should belong_to(:restaurant) }
    it { should belong_to(:role) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:phone_number) }
  end
end
