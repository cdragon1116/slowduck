class Chatroom < ApplicationRecord
  include Conversationable
  validates :name, presence: true, allow_blank: false, if: -> { not conversation? }

  has_many :chatroom_users, dependent: :destroy
  has_many :users, through: :chatroom_users, dependent: :destroy
  has_many :messages, dependent: :destroy
  has_many :notifications, as: :notifiable, dependent: :destroy

  accepts_nested_attributes_for :chatroom_users, :users
  after_commit :clear_associations, on: :destroy

  extend FriendlyId
  friendly_id :slugged_chatroom, use: :slugged

  def clear_associations
    notifications.destroy_all
  end

  def update_display(user, boolean)
    chatroom_users.where(user: user).update(display: boolean)
  end

  def users_with_image
    users.includes(image_attachment: :blob).order(online: :desc)
  end

  def online_users
    users.includes(image_attachment: :blob).where(online: 1)
  end

  def offline_users
    users.includes(image_attachment: :blob).where(online: 0)
  end

  def last_person?
    users.size == 1
  end

  def initialize_messages
    messages.includes(:parent, { user: {image_attachment: [:blob]}}, image_attachment: :blob ).order(created_at: :desc).limit(15).reverse
  end

  def tags
    messages_ids = messages.ids
    Tag.joins(:message_tags).where('message_id IN (?)', messages_ids).distinct
  end

  def add_list_users(users_list, current_user)
    users_list.each do |user|
      valid_user =  User.find_by(email: user) || User.find_by(username: user)
      chatroom_users.where(user_id: valid_user).first_or_create if valid_user
      notifications.create(recipient: valid_user, actor: current_user, action: 'invite')
    end
  end

  def notifications_with_related
    notifications.includes(:recipient, :actor)
  end

  private

  def slugged_chatroom
    SecureRandom.hex[0, 8]
  end
end
