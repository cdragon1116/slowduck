class RemoveMessageIdFromNotifications < ActiveRecord::Migration[5.2]
  def change
    remove_column :notifications, :message_id
  end
end
