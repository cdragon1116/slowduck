class Chatroom < ApplicationRecord
  validates :name, presence: true, allow_blank: false
  has_many :chatroom_users, dependent: :destroy
  has_many :users, through: :chatroom_users, dependent: :destroy
  has_many :messages, dependent: :destroy
  has_one :conversation , dependent: :destroy
  
  extend FriendlyId
    friendly_id :slugged_chatroom, use: :slugged

  def tags
    messages.map{|message| message.tags}.flatten.uniq
  end
  
  def normalize_friendly_id(input)
    input.to_s.to_slug.normalize.to_s
  end
  
    
  def one_on_one(current_user)
    self.users.where('user_id != ? ', current_user.id).first
  end

  private
  
  def slugged_chatroom
    [
      :name,
      [:name, SecureRandom.hex[0, 8]]
    ]
  end
  
end
