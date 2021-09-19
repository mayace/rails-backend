class User < ApplicationRecord
    has_secure_password
    has_many:sent_friendship_list, :class_name => "Friendship", :foreign_key => "sender_id"
    has_many:received_friendship_list, :class_name => "Friendship", :foreign_key => "receiver_id"
end
