class AddChatroomToConversations < ActiveRecord::Migration[5.2]
  def change
    add_reference :conversations, :chatroom, foreign_key: true
  end
end
