require 'rqrcode'

class Table < ApplicationRecord
  belongs_to :restaurant
  
  validates :name, presence: true

  before_create :generate_qrcode

  protected

  def generate_qrcode
    # TODO change url
    qr_code = RQRCode::QRCode.new("http://localhost:4500/#{restaurant_id}/#{id}")

    svg = qr_code.as_svg(
      color: "000",
      shape_rendering: "crispEdges",
      module_size: 11,
      standalone: true,
      use_path: true
    )
    self.last_generate_qr_code_at = Time.now
    self.qrcode = svg
  end
end
