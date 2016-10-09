# == Schema Information
#
# Table name: identities
#
#  id                     :integer          not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :inet
#  last_sign_in_ip        :inet
#  confirmation_token     :string
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  unconfirmed_email      :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#

class Identity < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,
         :registerable,
         :recoverable,
         :rememberable,
         :trackable,
         :validatable,
         :confirmable,
         :omniauthable

  before_save { self.email.downcase! }

  # attr_accessor :old_password

  validates :first_name,            length: { maximum: 50  }
  validates :last_name,             length: { maximum: 50  }
  validates :email, presence: true, length: { maximum: 255 }, uniqueness: { case_sensitive: false }

  belongs_to :backend_user, polymorphic: true, optional: true
  belongs_to :user,                            optional: true
  has_many :social_profiles

  # Returns the associated user if it exists. Otherwise creates and persists a new user.
  def user
    super || create_user
  end

  class << self

    # Makes current_identity available via Identity.
    # Set up in ApplicationController.
    def current_identity=(identity)
      Thread.current[:current_identity] = identity
    end

    # References current_identity via Identity.
    def current_identity
      Thread.current[:current_identity]
    end

    def from_omniauth(auth)

      # Search for the identity based on the authentication data.
      # Obtain a SocialProfile object that corresponds to the authentication data.
      profile = SocialProfile.find_or_create_from_omniauth(auth)

      # Obtain identity with the following precedence.
      # 1. Logged-in user's identity
      # 2. Identity with a registered profile.
      identity = current_identity || profile.identity

      # 3. Identity with verified email from omniauth.
      unless identity
        if auth.info.email
          identity  = Identity.where(email: auth.info.email).first
          profile.save_with_identity(identity)
        end
      end

      identity
    end
  end
end
