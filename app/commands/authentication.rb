require 'jwt'

class Authentication
  prepend SimpleCommand

  def initialize(username, password)
    @username = username
    @password = password
  end

  def call
    rsa_private = OpenSSL::PKey::RSA.new File.read(Rails.root.join('config', 'authkey.pem'))

    if user
      token = JWT.encode payload(user), rsa_private, 'RS256'

      return {
        auth_token: token,
        username: user.username,
        roles: user.roles.pluck(:name)
      }
    end
  end

  private

  attr_accessor :username, :password

  def payload(user)
    {
      data: {
        user_id: user.id,
        username: user.username
      },
      exp: (Time.now + 8.hours).to_i
    }
  end

  def user
    user = User.find_for_database_authentication(username: username)
    return user if valid_user?(user)

    errors.add :errors, 'Incorrect information'
    nil
  end

  def valid_user?(user)
    return user && user.valid_password?(password)
  end
end
