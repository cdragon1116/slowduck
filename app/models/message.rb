class Message < ApplicationRecord
  validates :body, presence: true, allow_blank: false
  belongs_to :user
  belongs_to :chatroom
  belongs_to :parent, class_name: :Message, optional: true
  has_many :messages, class_name: :Message, foreign_key: :parent_id

  has_many :message_tags, dependent: :destroy
  has_many :tags, through: :message_tags, dependent: :destroy

  after_create :set_parent

  extend FriendlyId
  friendly_id :slugged_message, use: :slugged

  private

  def set_parent
    if self.parent_id == nil
      self.update(parent_id: self.id)
    end
  end

  def slugged_message
    serial = [*"A".."Z", *0..9].sample(8).join
    "#{serial}#{body}"
  end

end


