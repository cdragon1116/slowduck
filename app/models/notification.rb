class Notification < ApplicationRecord
  belongs_to :recipient, class_name: 'User'
  belongs_to :actor, class_name: 'User'
  belongs_to :notifiable, polymorphic: true
  after_commit :broadcast, on: :create

  scope :unread, -> { where(read_at: nil) }

  def broadcast
    NotificationRelayJob.perform_later(self)
  end
end
