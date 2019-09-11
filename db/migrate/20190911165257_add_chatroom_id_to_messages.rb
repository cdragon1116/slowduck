class AddChatroomIdToMessages < ActiveRecord::Migration[5.2]
  def change
    add_reference :messages, :chatroom, foreign_key: true
  end
end
