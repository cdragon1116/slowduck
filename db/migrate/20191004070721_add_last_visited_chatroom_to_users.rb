class AddLastVisitedChatroomToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :last_visited_chatroom, :integer
  end
end
