class SocialProfile < ApplicationRecord
  belongs_to :identity

  store      :others

  validates_uniqueness_of :uid, scope: :provider

  # Returns a SocialProfile object that corresponds to the specified data.
  def self.find_or_create_from_omniauth(auth)
    find_or_create_by(uid: auth.uid, provider: auth.provider).tap do |profile|
      profile.save_omniauth_info(auth)
    end
  end

  def save_omniauth_info(auth)
    # Create params in correct format, then update the profile.
    self.update_attributes(params_from_omniauth(auth)) if valid_omniauth?(auth)
  end

  def save_with_identity(identity)
    # NOTE: Profile identity and the specified identity must match.
    self.update!(identity_id: identity.id) unless self.identity == identity
  end

  private

    # Returns params based on the specified authentication data.
    def params_from_omniauth(auth)
      class_name = "#{auth['provider']}".classify  # Facebook, Twitter etc.
      "SocialProfileParams::#{class_name}".constantize.new(auth).params
    end

    def valid_omniauth?(auth)
      (self.provider.to_s == auth['provider'].to_s) && (self.uid == auth['uid'])
    end
  end
