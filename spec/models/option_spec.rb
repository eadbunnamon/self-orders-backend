require 'rails_helper'

RSpec.describe Option, type: :model do
  describe 'associations' do
    it { should belong_to(:item) }
    it { should have_many(:sub_options) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:name_en) }
    it { should validate_uniqueness_of(:name).scoped_to(:item_id) }
    it { should validate_uniqueness_of(:name_en).scoped_to(:item_id) }
  end

  context 'if need to choose' do
    before { allow(subject).to receive(:need_to_choose?).and_return(true) }
    it { should validate_presence_of(:minimum_choose) }
    it { should validate_numericality_of(:minimum_choose).is_greater_than(0)}
  end

  context 'if no need to choose' do
    before { allow(subject).to receive(:need_to_choose?).and_return(false) }
    it { should_not validate_presence_of(:minimum_choose) }
    it { should_not validate_numericality_of(:minimum_choose).is_greater_than(0)}
  end

  context '#update_minimum_choose' do
    it 'if no need to choose any option' do
      option = FactoryBot.create(:option, need_to_choose: false)
      expect(option.minimum_choose).to eq(0)
    end
  end
end
