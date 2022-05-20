module AuthToken
  def token(user = FactoryBot.create(:user))
    rsa_private = OpenSSL::PKey::RSA.new File.read(Rails.root.join('config', 'authkey.pem'))
    payload = {
      data: {
        user_id: user.id,
        email: user.email
      },
      exp: (Time.now + 8.hours).to_i
    }
    JWT.encode payload, rsa_private, 'RS256'
  end
end
