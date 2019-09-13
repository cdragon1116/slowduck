class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
         
  validates :username, presence: true, allow_blank: false
  validates_uniqueness_of :username
         
  has_many :chatroom_users
  has_many :chatrooms , through: :chatroom_users
  has_many :messages, dependent: :destroy
end
