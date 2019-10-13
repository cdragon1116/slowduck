module Taggable
  extend ActiveSupport::Concern

  included do
    after_create :scan_tag, :scan_user, :set_parent, :set_color
  end

  def scan_user
    pattern = /(@\S*)/
    ary =  self.body.split(pattern)
    recipients = []
    new_ary = ary.map do |user|
      if user.start_with?('@') and find_user = User.find_by(username: user.sub('@', '').sub(',', '') )
        if find_user != self.user
          recipients << find_user
        end
          render_user = ApplicationController.renderer.render( partial:'users/user', locals: {user: find_user} )
      else
        user
      end
    end
    self.update(body: new_ary.join(""))
    recipients.uniq.each do |recipient|
      notification = Notification.create(recipient: recipient, actor: self.user, action: 'mention', notifiable: self)
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
    self.update(body: new_ary.join(""))
  end
end
