module Taggable
  extend ActiveSupport::Concern

  included do
    after_commit :scan_tag, :scan_user
  end

  def scan_user
    pattern = /(@\S*)/
    ary =  self.body.split(pattern)
    recipients = []
    new_ary = ary.each do |user|
      if user.start_with?('@') and find_user = User.find_by(username: user.sub('@', '').sub(',', '') )
        if find_user != self.user
          recipients << find_user
        end
      end
    end
    recipients.uniq.each do |recipient|
      notification = Notification.create(recipient: recipient, actor: self.user, action: 'mention', notifiable: self)
    end
  end

  def scan_tag
    pattern = /(#\S+)/
    ary =  self.body.split(pattern)
    new_ary = ary.each do |tag|
      tag_ary = tag.split("")
      if tag_ary.select{|x| x == '#'}.length == 1 and !tag_ary.include?(' ')
        new_tag = Tag.where(tagname: tag).first_or_create
        self.tags << new_tag
      end
    end
  end

end
