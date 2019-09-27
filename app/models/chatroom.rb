class Chatroom < ApplicationRecord
  validates :name, presence: true, allow_blank: false
  has_many :chatroom_users, dependent: :destroy
  has_many :users, through: :chatroom_users, dependent: :destroy
  has_many :messages, dependent: :destroy
  
  extend FriendlyId
    friendly_id :slugged_chatroom, use: :slugged

  def tags
    messages.map{|message| message.tags}.flatten.uniq
  end

  private
  
  def slugged_chatroom
    serial = [*"A".."Z", *0..9].sample(8).join
    "#{serial}#{name}"
  end
end
