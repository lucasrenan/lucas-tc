module V1
  class UserSerializer < ActiveModel::Serializer
    attributes :id, :email, :role
  end
end
