class AddStatusToChatrooms < ActiveRecord::Migration[5.2]
  def change
    add_column :chatrooms, :status, :string
  end
end
