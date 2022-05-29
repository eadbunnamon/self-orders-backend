require 'rails_helper'
require 'carrierwave/test/matchers'

describe ImageUploader do
  include CarrierWave::Test::Matchers

  let(:item) { FactoryBot.create(:item) }
  let(:uploader) { ImageUploader.new(item, :file) }

  before do
    ImageUploader.enable_processing = true
    File.open(Rails.root.join('spec', 'support', 'image_1.jpg')) { |f| uploader.store!(f) }
  end

  after do
    ImageUploader.enable_processing = false
    uploader.remove!
  end

  context 'the thumb version' do
    it "scales down a landscape image to be exactly 100 by 100 pixels" do
      expect(uploader.thumb).to be_no_larger_than(100, 100)
    end
  end

  context 'the small version' do
    it "scales down a landscape image to fit within 200 by 200 pixels" do
      expect(uploader.small).to be_no_larger_than(300, 300)
    end
  end

  it "makes the image readable only to the owner and not executable" do
    expect(uploader).to have_permissions(0666)
  end

  it "directory permissions" do
    expect(uploader).to have_directory_permissions(0777)
  end

  it "has the correct format" do
    expect(uploader).to be_format('jpeg')
  end

  it "extension_white_list" do
    expect(uploader.extension_allowlist).to match_array(%w(jpg jpeg gif png))
  end
end