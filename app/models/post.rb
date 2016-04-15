class Post < ApplicationRecord
  belongs_to :user

  validates :title, :text, :user, presence: true
end
