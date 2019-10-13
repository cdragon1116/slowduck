class ChatroomUser < ApplicationRecord
  belongs_to :user
  belongs_to :chatroom
  scope :show, -> { update(display: 1) }
  scope :hide, -> { update(display: 0) }
end
