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
         :omniauthable,
         omniauth_providers: [:facebook, :google_oauth2, :twitter]

  before_save { self.email.downcase! }

  validates :email, presence: true, length: { maximum: 255 }, uniqueness: { case_sensitive: false }

  belongs_to :backend_user, polymorphic: true, optional: true
  belongs_to :user,                            optional: true
  has_many :social_profiles

  TEMP_EMAIL_PREFIX = 'change@me'
  TEMP_EMAIL_REGEX = /\Achange@me/

  # Returns the associated user if it exists. Otherwise creates and persists a new user.
  def user
    super || create_user
  end

  # Returns a social profile object with the specified provider if any.
  def social_profile(provider)
    social_profiles.select{ |sp| sp.provider == provider.to_s }.first
  end

  # Returns true if the user has a verified email (not a temp email).
  def email_verified?
    self.email && self.email !~ TEMP_EMAIL_REGEX
  end

  # Used when we want to detect the email duplication error after form submission.
  def email_exists_in_database?
    (errors.messages.size == 1) && (errors.messages[:email].first == "has already been taken")
  end

  # Used when we want to detect the "already confirled" error after form submission.
  def email_already_confirmed?
    (errors.messages.size == 1) && (errors.messages[:email].first == "was already confirmed")
  end

  # Puts the user into the unconfirmed state.
  def reset_confirmation!
    self.update_column(:confirmed_at, nil)
  end

  # Marks the user as archived by prepending timestamp to its email.
  def archive!
    self.update_column(:email, "archived_at_#{Time.now.to_i}_#{self.email}")
  end

  # Associates social profiles of another user to this user.
  def merge_social_profiles(other)
    other.social_profiles.each { |profile| profile.save_with_identity(self) }
  end

  # Merges and archives the old account.
  def merge_old_account!(old_user)
    self.merge_social_profiles(old_user) unless old_user.social_profiles.empty?
    old_user.archive!

    # Set the total sign in count on the user.
    total_sign_in_count = self.sign_in_count + old_user.sign_in_count
    self.update_column(:sign_in_count, total_sign_in_count)

    # TODO: What else do we want to merge?
  end


  # ---
  # Class methods
  # ---


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

    def from_omniauth(auth_hash)

      # Search for the identity based on the authentication data.
      # Obtain a SocialProfile object that corresponds to the authentication data.
      profile = SocialProfile.find_or_create_from_omniauth(auth_hash)

      # Obtain identity with the following precedence.
      # 1. Logged-in user's identity
      # 2. Identity with a registered profile.
      identity = current_identity || profile.identity

      # 3. Identity with verified email from omniauth.
      unless identity
        if auth_hash.info.email
          identity  = Identity.where(email: auth_hash.info.email).first
          profile.save_with_identity(identity)
        end
      end

      # 4. New identity with a temp email.
      unless identity
        # If identity has no verified email, give the identity a temp email address.
        # Later, we can detect unregistered email based on TEMP_EMAIL_PREFIX.
        # Password is not required for identities with social_profiles therefore
        # it is OK to generate a random password for them.
        temp_email = "#{Identity::TEMP_EMAIL_PREFIX}-#{Devise.friendly_token[0,20]}.com"
        identity = Identity.new(email:    auth.info.email || temp_email,
                        password: Devise.friendly_token[0,20])
        identity.tap do |u|
          u.skip_confirmation!    # To postpone the delivery of confirmation email.
          u.save(validate: false) # Save the temp email to database, skipping validation.
          profile.save_with_identity(u)
        end
      end

      identity
    end
  end
end
