class Message < ApplicationRecord
  validates :body, presence: true, allow_blank: false
  belongs_to :user
  belongs_to :chatroom

  belongs_to :parent, :class_name => 'Message', optional: true
  has_many :messages, :class_name => 'Message', :foreign_key => 'parent_id'
end

