class AddColumnToChatroom < ActiveRecord::Migration[5.2]
  def change
    add_column :chatrooms, :public, :boolean, :default => false
  end
end
