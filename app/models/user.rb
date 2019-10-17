class User < ApplicationRecord
  include Omniauth
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :validatable,
    :omniauthable, omniauth_providers: [:facebook, :google_oauth2]

  before_create :remove_space

  validates :username, presence: true, allow_blank: false
  validates_uniqueness_of :username
  
  has_one_attached :image
  has_many :chatroom_users
  has_many :chatrooms, through: :chatroom_users
  has_many :messages, dependent: :destroy
  has_many :notifications, foreign_key: :recipient_id

  def group_chatrooms
    chatrooms.where(room_type: 0)
  end

  def conversations
    chatroom_ids = chatrooms.where(room_type: 1).ids

    display_room = chatroom_users.where(display: 1).pluck(:chatroom_id)
    chatrooms.where(room_type: 1).where(id: display_room)
  end

  def resize_image(size = 60)
    image.variant(resize: "#{size}x#{size}!").processed
  end

  def relative_users
    chatroom_ids = chatrooms.map(&:id)
    User.includes(image_attachment: :blob).joins(:chatroom_users).where('chatroom_id IN (?) ', chatroom_ids).distinct - [self]
  end

  def is_online
    update(online: true)
  end

  def is_offline
    update(online: false)
  end

  def online?
    online == 1
  end

  def remove_space
    self.username.gsub!(/\s+/, "")
  end

end
