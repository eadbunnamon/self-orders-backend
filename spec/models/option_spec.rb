require 'rails_helper'

RSpec.describe Option, type: :model do
  describe 'associations' do
    it { should belong_to(:item) }
    it { should have_many(:sub_options) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:name_en) }
    # it { should validate_uniqueness_of(:name).scoped_to(:item_id) }
    # it { should validate_uniqueness_of(:name_en).scoped_to(:item_id) }
  end

  context 'if need to choose' do
    before { allow(subject).to receive(:need_to_choose?).and_return(true) }
    it { should validate_presence_of(:minimum_choose) }
    it { should validate_numericality_of(:minimum_choose).is_greater_than(0)}
  end

  context 'if no need to choose' do
    before { allow(subject).to receive(:need_to_choose?).and_return(false) }
    it { should validate_presence_of(:minimum_choose) }
    it { should validate_numericality_of(:minimum_choose).is_equal_to(0)}
  end

  context 'if maximum_choose is presence' do
    before { allow(subject).to receive(:maximum_choose).and_return(1) }
    it { should_not validate_presence_of(:maximum_choose) }
    it { should validate_numericality_of(:maximum_choose).is_greater_than(0)}
  end

  context '#minimum_must_be_less_than_maximum' do
    it 'should invalid' do
      option = FactoryBot.build(:option, minimum_choose: 2, maximum_choose: 1)

      expect(option.valid?).to eq(false)
      expect(option.errors.full_messages).to include('เลือกขั้นต่ำต้องน้อยกว่าเลือกมากสุด')
    end
  end
end
