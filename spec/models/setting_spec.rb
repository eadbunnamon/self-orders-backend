require 'rails_helper'

RSpec.describe Setting, type: :model do
  it { should validate_presence_of(:currency ) }
  it { should validate_presence_of(:vat ) }
end
