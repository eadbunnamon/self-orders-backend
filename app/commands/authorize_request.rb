require 'jwt'

class AuthorizeRequest
  prepend SimpleCommand

  def initialize(headers = {})
    @headers = headers
  end

  def call
    user
  end

  private

  attr_reader :headers

  def user
    @user ||= User.find(decoded_token.first['data']['user_id']) if decoded_token
    @user || errors.add(:token, 'Invalid') && nil
  end

  def decoded_token
    rsa_private = OpenSSL::PKey::RSA.new File.read(Rails.root.join('config', 'authkey.pem'))
    rsa_public = rsa_private.public_key
    @decoded_token ||= JWT.decode token, rsa_public, true, { algorithm: 'RS256' }
  end

  def token
    if headers['Authorization'].present?
      return headers['Authorization'].split(' ').last
    else
      errors.add(:token, 'Could not find any token')
    end
    
    return nil
  end
end
