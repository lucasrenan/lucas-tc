class User < ApplicationRecord
  ROLES = ['guest', 'user', 'admin'].freeze
  enum role: ROLES

  has_many :posts
  has_many :devices

  validates :email, :password, :role, presence: true
  validates :email, uniqueness: true, if: :email_changed?
  validates :email, format: { with: /\A([\w\.%\+\-]+)@([\w\-]+\.)+([\w]{2,})\z/i },
    if: :email_changed?
  validates :role, inclusion: { in: ROLES }
end
