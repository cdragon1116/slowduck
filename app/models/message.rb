class Message < ApplicationRecord
  validates :body, presence: true, allow_blank: false
  belongs_to :user
  belongs_to :chatroom
  belongs_to :parent, class_name: :Message, optional: true
  has_many :messages, class_name: :Message, foreign_key: :parent_id
  has_many :notifications , dependent: :destroy

  has_many :message_tags, dependent: :destroy
  has_many :tags, through: :message_tags, dependent: :destroy

  after_save :scan_tag, :scan_user
  after_create :set_parent, :set_color

  extend FriendlyId
  friendly_id :slugged_message, use: :slugged
  

  private
  def slugged_message
    serial = [*"A".."Z", *0..9].sample(8).join
    "#{serial}#{body}"
  end

  def set_parent
    if self.parent_id == nil
      self.update(parent_id: self.id)
    end
  end

  def set_color
    if self.parent_id == self.id
      previous_color = (previous_parent == nil) ? 0 : previous_parent.color
      self.update(color: (previous_color + 1) % 4)
    else
      self.update(color: Message.find(self.parent_id).color)
    end
  end

  def previous_parent
    self.chatroom.messages.where('id < ?', self.id ).where('id = parent_id').last
  end

  def scan_user
    pattern = /(@\S*)/
    ary =  self.body.split(pattern)
    recipients = []
    new_ary = ary.map do |user|
      if user.start_with?('@') and find_user = User.find_by(username: user.sub('@', '').sub(',', '') )
        if find_user != self.user
          recipients << find_user
          render_user = ApplicationController.renderer.render( partial:'users/user', locals: {user: find_user} )
        else 
          render_user = ApplicationController.renderer.render( partial:'users/user', locals: {user: find_user} )
        end
      else
        user
      end
    end
    self.body = new_ary.join("")
    recipients.uniq.each do |recipient|
      Notification.create(recipient: recipient, actor: self.user, action: 'mention', notifiable: self, message_id: self.id)
    end
  end

  def scan_tag
    pattern = /(#\S+)/
    ary =  self.body.split(pattern)
    new_ary = ary.map do |tag|
      tag_ary = tag.split("")
      if tag_ary.select{|x| x == '#'}.length == 1 and !tag_ary.include?(' ')
          new_tag = Tag.where(tagname: tag).first_or_create
          self.tags << new_tag
          render_tag = ApplicationController.renderer.render( partial:'tags/tag', locals: {tag: new_tag} )
      else
        tag
      end
    end
    self.body = new_ary.join("")
  end

end


