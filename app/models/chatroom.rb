class Chatroom < ApplicationRecord
  validates :name, presence: true, allow_blank: false
  has_many :chatroom_users, dependent: :destroy
  has_many :users, through: :chatroom_users, dependent: :destroy
  has_many :messages, dependent: :destroy
  
end
