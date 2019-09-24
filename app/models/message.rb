class Message < ApplicationRecord
  validates :body, presence: true, allow_blank: false
  belongs_to :user
  belongs_to :chatroom
  belongs_to :parent, class_name: :Message, optional: true
  has_many :messages, class_name: :Message, foreign_key: :parent_id
  has_many :tags, dependent: :destroy

  after_create :set_parent

  private
  def set_parent
    if self.parent_id == nil
      self.update(parent_id: self.id)
    end
  end
end


