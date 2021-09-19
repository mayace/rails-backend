class UserSerializer < ActiveModel::Serializer
  attributes :id, :username, :email, :fullname, :photo
  has_many :sent_friendship_list
  has_many :received_friendship_list
end
