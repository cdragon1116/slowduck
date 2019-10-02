class AddDisplayToChatroomUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :chatroom_users, :display, :boolean, default: true 
  end
end
