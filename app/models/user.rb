class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [:facebook, :google_oauth2]
         
  validates :username, presence: true, allow_blank: false
  validates_uniqueness_of :username
  has_one_attached :image
  before_save :default_image
         
  has_many :chatroom_users
  has_many :chatrooms , through: :chatroom_users
  has_many :messages, dependent: :destroy
  def resize_image(size = '60x60!')
    if !self.image.attached?
      self.image.attach(io: File.open(Rails.root.join('app', 'assets', 'images', 'default_user_image.png')), filename: 'default_user_img.png', content_type: 'image/png')
    end
    return self.image.variant(resize: size).processed
  end
  def default_image
    if self.image == nil 
      self.image.attach(io: File.open(Rails.root.join('app', 'assets', 'images', 'default_user_image.png')), filename: 'default_user_img.png', content_type: 'image/png')
    end
  end

  

  def self.find_for_google_oauth2(access_token, signed_in_resource=nil)
    data = access_token.info
    user = User.where(:google_token => access_token.credentials.token, :google_uid => access_token.uid ).first    
    if user
      return user
    else
      existing_user = User.where(:email => data["email"]).first
      if  existing_user
        existing_user.google_uid = access_token.uid
        existing_user.google_token = access_token.credentials.token
        existing_user.save!
        return existing_user
      else
    # Uncomment the section below if you want users to be created if they don't exist
        user = User.create(
            username: data["name"],
            email: data["email"],
            password: Devise.friendly_token[0,20],
            google_token: access_token.credentials.token,
            google_uid: access_token.uid
          )
      end
    end
  end

  def self.from_omniauth(auth)
    # Case 1: Find existing user by facebook uid
    user = User.find_by_fb_uid( auth.uid )
    if user
      user.fb_token = auth.credentials.token
      user.save!
      return user
    end
    # Case 2: Find existing user by email
    existing_user = User.find_by_email( auth.info.email )
    if existing_user
      existing_user.fb_uid = auth.uid
      existing_user.fb_token = auth.credentials.token
      existing_user.save!
      return existing_user
    end
    # Case 3: Create new password
    user = User.new
    user.fb_uid = auth.uid
    user.fb_token = auth.credentials.token
    user.email = auth.info.email
    user.password = Devise.friendly_token[0,20]
    user.username = auth.info.name
    user.save!
    return user
  end
end
