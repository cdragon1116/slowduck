class Message < ApplicationRecord
  belongs_to :user
  belongs_to :post
  belongs_to :chatroom
end
