require 'rails_helper'

RSpec.describe Restaurant, type: :model do
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:name_en) }
  it { should validate_presence_of(:open_time) }
  it { should validate_presence_of(:close_time) }
end
