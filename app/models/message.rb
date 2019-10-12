class Message < ApplicationRecord
  validates :body, presence: true, allow_blank: false
  belongs_to :user
  belongs_to :chatroom
  belongs_to :parent, class_name: :Message, optional: true
  has_many :messages, class_name: :Message, foreign_key: :parent_id
  has_many :notifications, as: :notifiable, dependent: :destroy
  has_many :message_tags, dependent: :destroy
  has_many :tags, through: :message_tags, dependent: :destroy

  include Taggable
  after_create :set_parent, :set_color
  before_update :clear_associations

  extend FriendlyId
  friendly_id :slugged_message, use: :slugged

  def clear_associations
    notifications.destroy_all
    message_tags.destroy_all
  end

  def initialize_messages
    messages.includes(:parent, :chatroom, :user => :image_attachment).order(created_at: :desc).reverse
  end

  private

  def slugged_message
    SecureRandom.hex[0, 8]
  
  end

  def set_parent
    update(parent_id: id) if parent_id.nil?
  end

  def set_color
    if parent_id == id
      update(color: 0)
    elsif Message.where(parent_id: parent_id).length == 2
      previous_color = (previous_parent.nil?) ? 0 : previous_parent.color
      update_column(:color, (previous_color + 1) % 3 + 1)
      Message.find(parent_id).update_column(:color, color)
    else
      update_column(:color,  Message.find(parent_id).color)
    end
  end

  def previous_parent
    chatroom.messages.where('id < ?', id).where('id = parent_id').where('color > 0').last
  end
end
