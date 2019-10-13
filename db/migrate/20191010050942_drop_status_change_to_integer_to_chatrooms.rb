class DropStatusChangeToIntegerToChatrooms < ActiveRecord::Migration[5.2]
  def change
    remove_column :chatrooms, :status, :string
    add_column :chatrooms, :room_type, :integer, default: 0
  end
end
