class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  before_create :set_auth_token

  private
  def set_auth_token
    self.auth_token = generate_auth_token
  end

  def generate_auth_token
    loop do
      auth_token = SecureRandom.base58(24)
      break auth_token unless User.exists?(auth_token: auth_token)
    end
  end
end
