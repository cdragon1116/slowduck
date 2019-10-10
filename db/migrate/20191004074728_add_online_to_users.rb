class AddOnlineToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :online, :integer, default: false
  end
end
