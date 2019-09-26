class Tag < ApplicationRecord
  has_many :messages , through: :message_tag
  has_many :message_tags

  validates :tagname, presence: true, uniqueness: { allow_blank: false, case_sensitive: true }

  def self.scan_tag(message)
    pattern = /(#\S+)/
    ary =  message.body.split(pattern)
    new_ary = ary.map do |tag|
      if tag.start_with?('#')
        new_tag = Tag.where(tagname: tag).first_or_create
        message.tags << new_tag
        render_tag = ApplicationController.renderer.render( partial:'tags/tag', locals: {tag: new_tag} )
      else
        tag
      end
    end
    message.update(body: new_ary.join(""))
  end
end
