class AddSlugToChatrooms < ActiveRecord::Migration[5.2]
  def change
    add_column :chatrooms, :slug, :string
    add_index :chatrooms, :slug, unique: true
  end
end
