class User < ApplicationRecord
  ROLES = ['guest', 'user', 'admin'].freeze
  enum role: ROLES

  has_secure_password

  has_many :posts
  has_many :devices

  validates :email, :role, presence: true
  validates :email, uniqueness: true, if: :email_changed?
  validates :email, format: { with: /\A([\w\.%\+\-]+)@([\w\-]+\.)+([\w]{2,})\z/i },
    if: :email_changed?
  validates :role, inclusion: { in: ROLES }
  validates :access_token, uniqueness: true

  before_create :generate_access_token!

  # based on Devise.friendly_token
  # https://github.com/plataformatec/devise/blob/846ba804803cf265480801f1d0e13d45b5ba3c68/lib/devise.rb#L561
  def generate_access_token!
    loop do
      self.access_token = SecureRandom.urlsafe_base64(15).tr('lIO0', 'sxyz')
      break access_token unless self.class.exists?({ access_token: access_token })
    end
  end
end
