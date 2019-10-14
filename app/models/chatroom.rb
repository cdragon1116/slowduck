class Chatroom < ApplicationRecord
  validates :name, presence: true, allow_blank: false
  has_many :chatroom_users, dependent: :destroy
  has_many :users, through: :chatroom_users, dependent: :destroy
  has_many :messages, dependent: :destroy
  has_one :conversation , dependent: :destroy
  has_many :notifications, as: :notifiable, dependent: :destroy

  
  extend FriendlyId
  friendly_id :slugged_chatroom, use: :slugged

  def update_display(user, boolean)
    chatroom_users.where(user: user).update(display: boolean)
  end

  def online_users
    users.where(online: 1)
  end

  def offline_users
    users.where(online: 0)
  end

  def initialize_messages
    messages.includes(:parent, :user => :image_attachment ).order(created_at: :desc).limit(15).reverse
  end

  def tags
    messages_ids = self.messages.ids
    Tag.joins(:message_tags).where('message_id IN (?)', messages_ids).distinct
  end
  
  def conversation_with(current_user)
    users.where('user_id != ? ', current_user.id).first
  end

  private
  def slugged_chatroom
    SecureRandom.hex[0, 8]
  end
end
