module V1
  class PostSerializer < ActiveModel::Serializer
    attributes :id, :title, :text, :user_id
  end
end
