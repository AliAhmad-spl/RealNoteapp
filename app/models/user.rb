class User < ApplicationRecord
  devise :omniauthable, :omniauth_providers => [:google_oauth2]
  has_many :notes

  def self.from_omniauth(access_token)
    data = access_token.info
    user = User.where(:email => data["email"]).first

    unless user
      user = User.create(
            name: data["name"],
            email: data["email"],
            encrypted_password: Devise.friendly_token[0,20]
      )
    end
    user
  end
end
