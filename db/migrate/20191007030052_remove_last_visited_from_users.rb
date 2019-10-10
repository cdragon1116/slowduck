class RemoveLastVisitedFromUsers < ActiveRecord::Migration[5.2]
  def change
    remove_column :users, :last_visited_chatroom
  end
end
