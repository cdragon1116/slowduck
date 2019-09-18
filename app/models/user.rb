class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
         
  validates :username, presence: true, allow_blank: false
  validates_uniqueness_of :username
  has_one_attached :image
  before_save :default_image
         
  has_many :chatroom_users
  has_many :chatrooms , through: :chatroom_users
  has_many :messages, dependent: :destroy
  def resize_image(size = '60x60!')
    if self.image
      return self.image.variant(resize: size).processed
    end
  end
  def default_image
    if self.image == nil 
      self.image.attach(io: File.open(Rails.root.join('app', 'assets', 'images', 'default_user_image.png')), filename: 'default_user_img.png', content_type: 'image/png')
    end
  end
end
