require "securerandom"

class UserSecret
  include Mongoid::Document
  include Mongoid::Timestamps

  field :user_id, :type => String
  field :secret,  :type => String

  validates :user_id,   :presence => true
  validates :secret,   :presence => true

  before_validation do |user_secret|
    if user_secret.secret.blank?
      user_secret.secret = SecureRandom.hex(16)
    end
  end

  module UserMethods
    def user_secret
      UserSecret.where(:user_id => self.id.to_s).first
    end

    def secret
      self._create_or_find_user_secret
      user_secret.secret
    end

    def _create_or_find_user_secret
      user_secret = self.user_secret
      if user_secret.blank?
        user_secret = UserSecret.create(
          :user_id => self.id.to_s, 
          :secret => SecureRandom.hex(16)
        )
      end
      user_secret
    end
  end
end
